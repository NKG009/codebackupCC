export async function onAfterCalculate(quoteModel, quoteLineModels) {
    resetLineValidation(quoteModel);
    //Get an array of quote lines where the VariantRT field is filled in and it contains 'error', we will use this array for building the html to        display inside of our popup.
    const quoteLinesWithErrors = quoteLineModels.filter(e => e.record['VariantRT__c'] && e.record['VariantRT__c'].includes('error'));
    if (window && getEventHandler().includes('save') && quoteLinesWithErrors.length) {
        //If the quote has error lines, check linevalidation, which will fire our validation rule
        quoteModel.record["LineValidation__c"] = true;
        //Define our callback function, we need to resolve our promise in both cases, since otherwise the new values on our quote/quote lines will not be saved.
        const waitForConfirmation = new Promise((resolve, reject) => {
            const dialogCallback = (ret) => {
                if (ret) {
                    //If the user continues, bypass the validation rule
                    quoteModel.record["BypassLineValidation__c"] = true;
                    resolve();
                } else {
                    //If the user cancels, do not bypass the validation rule
                    quoteModel.record["BypassLineValidation__c"] = false;
                    resolve();
                    return;
                }
            };
            //Create a list of messages, containing the quote line number and the product name
            const messages = quoteLinesWithErrors.map(line => `${line.record['SBQQ__Number__c']}: ${line.record['SBQQ__ProductName__c']}`);
            //Create an html body, containing a paragraph and our   messages, seperated by a new line (<br />)
            let body = `<p>Errors on the following lines : <br /> <span style="color:red;font-weight:bold">${messages.join('<br />')}</span></p>`;
            //Call our dialog window and provide our callback function
            window.sb.dialog.confirm(body, {
                ok: 'Save anyway',
                cancel: 'Cancel'
            }, dialogCallback);
        });
        return await waitForConfirmation;
    }
    return Promise.resolve();
}

/**
 * @description reset the validation fields on our quote
 * @param quoteModel the current quote model
 */
const resetLineValidation = (quoteModel) => {
    quoteModel.record["LineValidation__c"] = false;
    quoteModel.record["BypassLineValidation__c"] = false;
}

/**
 * @description When inside of the QLE, get the properties related to the current processed action and extract the event handler name (onFlagCalculate, onQuickSave,...)
 * @returns The current event handler name
 */
const getEventHandler = () => {
    if (window) {
        const actionServices = document.querySelector('sb-page-container').shadowRoot.querySelector('sb-line-editor').shadowRoot.querySelector('sb-le-custom-action-services');
        if (actionServices.eventDetail) {
            return actionServices.eventDetail.customAction.eventHandlerName.toLowerCase();
        }
    }
    return '';
}

/*
============================================================
 Quote Calculator Plugin (QCP)
 Replicates Apttus validation logic in Salesforce CPQ Quote Line Editor (QLE)
============================================================
*/

export function onBeforeCalculate(quote, lines, conn) {
    let errors = [];
    let warnings = [];

    // -----------------------------------------
    // 1. SKIP IF ANY LINE HAS Mass Update = 'Yes'
    // -----------------------------------------
    let isMassUpdate = lines.some(line => line.record['APTS_Mass_Update__c'] === 'Yes');
    if (isMassUpdate) {
        return Promise.resolve();
    }

    // -----------------------------------------
    // 2. FINAL UNIT PRICE CAN'T BE ZERO
    // -----------------------------------------
    lines.forEach(line => {
        if (line.record['APTS_Final_Unit_Price__c'] === 0) {
            errors.push({
                message: `Line ${line.record['SBQQ__LineNumber__c']}: Final Unit Price cannot be 0.`,
                level: 'error',
                line: line
            });
        }
    });

    // -----------------------------------------
    // 3. VENDOR VALIDATION
    // -----------------------------------------
    lines.forEach(line => {
        const cat = line.record['APTS_Item_Category__c'];
        const vendor = line.record['APTS_Vendor_Name__c'];

        if (['KB Order(Direct)', 'Project w/ Spec', 'Project w/o Spec'].includes(cat) && !vendor) {
            errors.push({
                message: `Line ${line.record['SBQQ__LineNumber__c']}: Vendor selection is mandatory.`,
                level: 'error',
                line: line
            });
        }
        if (!['KB Order(Direct)', 'Project w/ Spec', 'Project w/o Spec'].includes(cat) && vendor) {
            errors.push({
                message: `Line ${line.record['SBQQ__LineNumber__c']}: Vendor must be blank for this Item Category.`,
                level: 'error',
                line: line
            });
        }
    });

    // -----------------------------------------
    // 4. ITEM CATEGORY VALIDATIONS
    // -----------------------------------------
    lines.forEach(line => {
        const cat    = line.record['APTS_Item_Category__c'];
        const specPkg= line.record['APTS_Spec_Pkg_Code__c'];
        const specDesc= line.record['APTS_Spec_Desc__c'];
        const factoryCost = line.record['APTS_Vendor_Cost__c'];
        const basePriceOverride = line.record['SBQQ__SpecialPrice__c'];

        if (!cat) {
            errors.push({
                message: `Line ${line.record['SBQQ__LineNumber__c']}: Item Category cannot be blank.`,
                level: 'error',
                line: line
            });
            return;
        }

        // Indent Order(Product) must have Spec Package
        if (cat === 'Indent Order(Product)' && !specPkg) {
            errors.push({
                message: `Line ${line.record['SBQQ__LineNumber__c']}: Spec Package Code is required.`,
                level: 'error',
                line: line
            });
        }

        // KB Order Direct must have factory cost
        if (cat === 'KB Order(Direct)' && (!factoryCost || factoryCost === 0)) {
            errors.push({
                message: `Line ${line.record['SBQQ__LineNumber__c']}: Factory/Mod Cost is required.`,
                level: 'error',
                line: line
            });
        }

        // Individual Spec logic
        if (cat === 'Individual Spec') {
            if (specPkg) {
                errors.push({
                    message: `Line ${line.record['SBQQ__LineNumber__c']}: Spec Package must be blank.`,
                    level: 'error',
                    line: line
                });
            }
            if (!specDesc) {
                errors.push({
                    message: `Line ${line.record['SBQQ__LineNumber__c']}: Spec Description is required.`,
                    level: 'error',
                    line: line
                });
            }
        }

        // Project Specifications logic
        if (['Project w/ Spec','Project w/o Spec'].includes(cat)) {
            if (!specDesc) {
                errors.push({
                    message: `Line ${line.record['SBQQ__LineNumber__c']}: Spec Description is required.`,
                    level: 'error',
                    line: line
                });
            }
            if (!factoryCost || factoryCost === 0) {
                errors.push({
                    message: `Line ${line.record['SBQQ__LineNumber__c']}: Factory/Mod Cost is required.`,
                    level: 'error',
                    line: line
                });
            }
            if (!basePriceOverride || basePriceOverride === 0) {
                errors.push({
                    message: `Line ${line.record['SBQQ__LineNumber__c']}: Custom Unit Price is required.`,
                    level: 'error',
                    line: line
                });
            }
        }
    });

    // -----------------------------------------
    // 5. WAREHOUSE & CATEGORY RULES
    // -----------------------------------------
    lines.forEach(line => {
        const cat = line.record['APTS_Item_Category__c'];
        const wh  = line.record['APTS_Warehouse_Number__c'];
        const specDesc = line.record['APTS_Spec_Desc__c'];

        // Warehouse must be blank for direct & spec
        if (['KB Order(Direct)','Individual Spec'].includes(cat) && wh) {
            errors.push({
                message: `Line ${line.record['SBQQ__LineNumber__c']}: Warehouse must be blank for selected category.`,
                level: 'error',
                line: line
            });
        }
        // Indent Orders must only be warehouse 3099
        if (['Indent Order(Product)','Indent Order(Parts)'].includes(cat) && wh !== '3099') {
            errors.push({
                message: `Line ${line.record['SBQQ__LineNumber__c']}: Invalid warehouse for this category.`,
                level: 'error',
                line: line
            });
        }
        // Special warehouse rules
        if (wh === '3008' && cat !== 'Stock Order') {
            errors.push({
                message: `Line ${line.record['SBQQ__LineNumber__c']}: Only Stock Orders allowed in warehouse 3008.`,
                level: 'error',
                line: line
            });
        }
        if (wh && wh.startsWith('30W') && cat !== 'Consigned Stock Order') {
            errors.push({
                message: `Line ${line.record['SBQQ__LineNumber__c']}: Only Consigned Stock Orders allowed in this warehouse.`,
                level: 'error',
                line: line
            });
        }
        // Spec must be blank for stock/indent types
        if (['Stock Order','Consigned Stock Order','Indent Order(Product)','Indent Order(Parts)'].includes(cat) && specDesc) {
            errors.push({
                message: `Line ${line.record['SBQQ__LineNumber__c']}: Spec Description must be blank for selected category.`,
                level: 'error',
                line: line
            });
        }
    });

    // -----------------------------------------
    // 6. INVENTORY WARNINGS
    // -----------------------------------------
    lines.forEach(line => {
        const estQty = line.record['APTS_Est_Available_Quantity__c'];
        const wh     = line.record['APTS_Warehouse_Number__c'];
        const cat    = line.record['APTS_Item_Category__c'];

        if (estQty < 0 && wh && wh !== '3099' && cat !== 'Individual Spec') {
            warnings.push({
                message: `Line ${line.record['SBQQ__LineNumber__c']}: Insufficient inventory.`,
                level: 'warning',
                line: line
            });
        }
    });

    // -----------------------------------------
    // THROW ERRORS / WARNINGS
    // -----------------------------------------
    if (errors.length) {
        throw errors;
    }
    if (warnings.length) {
        throw warnings;
    }

    return Promise.resolve();
}















