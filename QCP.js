export function onBeforeCalculate(quote, lines, conn) {
    console.log('🚀 QCP onBeforeCalculate fired');
   /* return updatingPriceUsingPriceMatrixV2(quote, lines, conn).then(() => {
        console.log('🚀 QCP onBeforeCalculate completed');
         return Promise.resolve();
    });*/
console.log('Quote record on before calculate:', quote.record);
console.log('quote massupdate fileds:', quote.record['Item_Category_Mass_Update__c'], quote.record['Multiplier_Mass_Update__c']);
console.log('lines on before calculate:', lines.map(line => ({ record: line.record })));
let itemCategorymassupdate=quote.record['Item_Category_Mass_Update__c'];
let multiplierMassUpdate=quote.record['Multiplier_Mass_Update__c'];
let quoteData;
let productData;
return fetchQuoteData(quote, conn)
    .then(function (quoteResult) {
        quoteData = quoteResult;
        console.log('Fetched quote data:', quoteData);   
        return fetchProducts(lines, conn);
    })
    .then(function (productResult) {
        productData=productResult;
       return fetchcostdata(lines,conn,productData);
        
    })
    .then(function () {
       return fetchlistpricedata(lines,conn,productData,quoteData.Quote_Created_Date__c);
        
    })
    .then(function (costdata){
        return fetchAndApplyPricingMatrixNetprices(quoteData, lines, productData, conn);
    })
    .then(function () {
            if (quoteData.Project__c != null) {
                console.log('Applying Project Based Pricing');

                return fetchProjectPricingMatrix(quoteData,lines,productData,conn)
                .then(function(projectPricingData) {

                    applyProjectPricingRules(quoteData,lines,projectPricingData);
                    return Promise.resolve();
                });
            }

            return Promise.resolve();
        })
    .then(function (costdata){
        return fetchPricingMatrix(quoteData, lines, productData, conn);
    })
    .then(function (matrixData) {
        applyPricingRules(quoteData, lines, matrixData,itemCategorymassupdate,multiplierMassUpdate);
        return Promise.resolve();
    });

   
}
export function onAfterCalculate(quote, lines, conn) {
    console.log('QCP onAfterCalculate', lines.length);
    
    let errors = [];

   // console.log('window:', window);
   // console.log('getEventHandler():', getEventHandler());
    // Reset all QL_Validation__c flags to false 
    lines.forEach(line => {
        if (line.record["QL_Validation__c"] == true) {
            line.record["QL_Validation__c"] = false;
        }
    });

    if (window && getEventHandler() == 'onSave' || getEventHandler() == 'onsave') {
        // errors = validationcheck(lines, conn);
        return validationcheck(lines, conn).then(function (errors) {
            console.log('errors.length before validation check:', errors.length);
            highlightValidationErrors(lines);
            if (errors.length > 0) {
                
                
            
                let body = `<div style="max-height:200px !important; overflow-y:auto !important; padding-right:8px;border:1px solid #ea001e;background-color:#fef1f2;border-radius:6px;padding:16px;font-family:Salesforce Sans,Arial,sans-serif;"><div style="display:flex;align-items:center;margin-bottom:12px;color:#c23934;font-size:16px;font-weight:700;"><span style="font-size:20px;margin-right:8px;">❌</span>Validation Error</div><div style="font-size:14px;color:#080707;margin-bottom:6px;">Errors found on the following line(s):</div><div style="font-size:14px;color:#c23934;font-weight:600;line-height:1.6;margin-left:8px;">${errors.join('<br/>')}</div></div>`;
                //Call our dialog window and provide our callback function
                window.sb.dialog.alert(body, {
                    ok: 'Okay',
                    cancel: 'Cancel'
                });

            }
        });
    }
    return Promise.resolve();
}



const getEventHandler = () => {
    if (window) {
        const actionServices = document.querySelector('sb-page-container').shadowRoot.querySelector('sb-line-editor').shadowRoot.querySelector('sb-le-custom-action-services');
        console.log('actionServices:', actionServices);
        console.log('actionServices.eventDetail:', actionServices.eventDetail);
        if (actionServices.eventDetail) {
            return actionServices.eventDetail.customAction.eventHandlerName.toLowerCase();
        }
    }
    return '';

}

function validationcheck(lines, conn) {
    let errors = [];



    /************************** 1.VENDOR VALIDATION***************************/
    lines.forEach(line => {
        const cat = line.record['Item_Category__c'];
        const vendor = line.record['Vendor_Name__c'];

        if (['KB Order(Direct)', 'Project w/ Spec', 'Project w/o Spec'].includes(cat) && !vendor) {
            line.record["QL_Validation__c"] = true;
            errors.push(`Line ${line.record['SBQQ__Number__c']}: Vendor selection is mandatory.`);
        }
        if (!['KB Order(Direct)', 'Project w/ Spec', 'Project w/o Spec'].includes(cat) && vendor) {
            line.record["QL_Validation__c"] = true;
            errors.push(`Line ${line.record['SBQQ__Number__c']}: Vendor must be blank for this Item Category.`);
        }
    });



    /************************** 2.WAREHOUSE AND ITEM CATEGORY VALIDATION***************************/
    lines.forEach(line => {



        const itemCategory = line.record['Item_Category__c'];
        const warehouseName = line.record['Warehouse__c'];
        const warehouseNumber = line.record['Warehouse_Number__c'];
        const warehouseLocation = line.record['Warehouse_Location__c'];
        const specDesc = line.record['Spec_Desc__c'];
        const availableQty = line.record['Available_Qty__c'];
        const lineNumber = line.record['SBQQ__Number__c'];

        /* KB Order(Direct) OR Individual Spec → warehouse fields must be blank */
        console.log('Validating warehouse for line', lineNumber, 'Item Category:', itemCategory);
        console.log('warehouse fileds:', warehouseName, warehouseNumber, warehouseLocation, availableQty); 
        if (
            (itemCategory === 'KB Order(Direct)' || itemCategory === 'Individual Spec') &&
            (
                warehouseName ||
                warehouseNumber ||
                warehouseLocation ||
                availableQty !== null
            )
        ) {
           /* line.record["QL_Validation__c"] = true;
            errors.push(
                `Line ${lineNumber}: Warehouse fields must be blank for selected Item Category.`
            );*/
        }

        /* Indent Orders → only warehouse 3099 allowed */
        else if (
            (itemCategory === 'Indent Order(Product)' || itemCategory === 'Indent Order(Parts)') &&
            warehouseNumber !== '3099' && warehouseNumber !== null
        ) {
            /*line.record["QL_Validation__c"] = true;
            errors.push(
                `Line ${lineNumber}: Invalid Item Category for selected Warehouse. Please correct Item Category or re-select a different warehouse.`
            );*/
        }

        /* Warehouse 3008 → only Stock Order */
        else if (
            itemCategory !== 'Stock Order' &&
            warehouseNumber === '3008' && warehouseNumber !== null
        ) {
           /* line.record["QL_Validation__c"] = true;
            errors.push(
                `Line ${lineNumber}: Invalid Item Category for selected Warehouse. Please correct Item Category or re-select a different warehouse.`
            );*/
        }

        /* 30W warehouses → only Consigned Stock Order */
        else if (
            warehouseNumber &&
            warehouseNumber.includes('30W') &&
            itemCategory !== 'Consigned Stock Order'
        ) {
           /* line.record["QL_Validation__c"] = true;
            errors.push(
                `Line ${lineNumber}: Invalid Item Category for selected Warehouse. Please correct Item Category or re-select a different warehouse.`
            );*/
        }

        /* Spec Desc must be blank for these categories */
        else if (
            (
                itemCategory === 'Consigned Stock Order' ||
                itemCategory === 'Stock Order' ||
                itemCategory === 'Indent Order(Product)' ||
                itemCategory === 'Indent Order(Parts)'
            ) &&
            specDesc
        ) {
            /*
            line.record["QL_Validation__c"] = true;
            errors.push(
                `Line ${lineNumber}: Spec Desc must be blank for selected Item Category.`
            );*/
        }

    });

    /************************** 3.Item Category validation***************************/
    lines.forEach(line => {

        const itemCategory = line.record['Item_Category__c'];
        const specPkgCode = line.record['Spec_Package_Code__c'];
        const specDesc = line.record['Spec_Desc__c'];

        const cost = line.record['Prod_Cost__c'];
        const factoryModCost = line.record['Factory_Mod_Cost__c'];
        const basePriceOverride = line.record['SBQQ__BasePriceOverride__c'];

        const lineNumber = line.record['SBQQ__Number__c'];

        console.log('Validating Item Category for line', lineNumber, 'Item Category:', itemCategory);
        console.log('Spec Pkg Code:', specPkgCode, 'Spec Desc:', specDesc, 'Cost:', cost, 'Factory/Mod Cost:', factoryModCost);

        /* Item Category cannot be null */
        if (!itemCategory) {
            line.record["QL_Validation__c"] = true;
            errors.push(
                `Line ${lineNumber}: Item Category cannot be NULL.`
            );
            return;
        }

        /* ===============================
           Indent Order (Product)
        =============================== */
        if (itemCategory === 'Indent Order(Product)') {

            if (!specPkgCode) {
                line.record["QL_Validation__c"] = true;
                errors.push(
                    `Line ${lineNumber}: Invalid Item Category since Spec Pkg Code is BLANK.`
                );
            }
            else if (
                specPkgCode &&
                (!cost || cost === 0) &&
                (!factoryModCost || factoryModCost === 0)
            ) {
                line.record["QL_Validation__c"] = true;
                errors.push(
                    `Line ${lineNumber}: Factory/Mod Cost cannot be NULL or 0.`
                );
            }
        }

        /* ===============================
           KB Order (Direct)
        =============================== */
        if (
            itemCategory === 'KB Order(Direct)' &&
            (!factoryModCost || factoryModCost === 0)
        ) {
            line.record["QL_Validation__c"] = true;
            errors.push(
                `Line ${lineNumber}: Factory/Mod Cost cannot be zero or blank.`
            );
        }

        if (
            itemCategory === 'KB Order(Direct)' &&
            !specDesc
        ) {
            line.record["QL_Validation__c"] = true;
            errors.push(
                `Line ${lineNumber}: Spec Desc cannot be Empty.`
            );
        }

        /* ===============================
           Individual Spec
        =============================== */
        if (itemCategory === 'Individual Spec') {

            if (specPkgCode) {
                line.record["QL_Validation__c"] = true;
                errors.push(
                    `Line ${lineNumber}: Invalid Item Category since Spec Pkg Code is NOT BLANK.`
                );
            }
            else if (!specPkgCode && !specDesc) {
                line.record["QL_Validation__c"] = true;
                errors.push(
                    `Line ${lineNumber}: Spec Desc cannot be Empty.`
                );
            }
            else if (
                !specPkgCode &&
                specDesc &&
                (!cost || cost === 0) &&
                (!factoryModCost || factoryModCost === 0)
            ) {
                line.record["QL_Validation__c"] = true;
                errors.push(
                    `Line ${lineNumber}: Factory/Mod Cost cannot be NULL or 0.`
                );
            }
        }

        /* ===============================
           Indent Order (Parts)
        =============================== */
        if (
            itemCategory === 'Indent Order(Parts)' &&
            (!cost || cost === 0) &&
            (!factoryModCost || factoryModCost === 0)
        ) {
            line.record["QL_Validation__c"] = true;
            errors.push(
                `Line ${lineNumber}: Factory/Mod Cost cannot be NULL or 0.`
            );
        }

        /* ===============================
           Stock / Consigned / Project Stock
        =============================== */
        if (
            (
                itemCategory === 'Project Stock Order' ||
                itemCategory === 'Stock Order' ||
                itemCategory === 'Consigned Stock Order'
            ) &&
            factoryModCost !== null
        ) {
            line.record["QL_Validation__c"] = true;
            errors.push(
                `Line ${lineNumber}: Factory/Mod Cost must be blank for selected Item Category.`
            );
        }

        /* ===============================
           Project Orders
        =============================== */
        if (
            itemCategory === 'Project w/ Spec' ||
            itemCategory === 'Project w/o Spec'
        ) {

            if (!specDesc) {
                line.record["QL_Validation__c"] = true;
                errors.push(
                    `Line ${lineNumber}: Spec Desc cannot be Empty.`
                );
            }

            if (!factoryModCost || factoryModCost === 0) {
                line.record["QL_Validation__c"] = true;
                errors.push(
                    `Line ${lineNumber}: Factory/Mod Cost cannot be NULL or 0.`
                );
            }

            /* if (!basePriceOverride || basePriceOverride === 0) {
                 errors.push(
                     `Line ${lineNumber}: Custom Unit Price is required. Please enter Adjustment Amount or Override Multiplier and reprice the cart.`
                 );
             }*/
        }

    });


    /**************4.INVENTORY WARNINGS & FINAL UNIT PRICE VALIDATION**************/
    lines.forEach(line => {
        const finalUnitPrice = line.record['SBQQ__NetPrice__c'];
        const lineNumber = line.record['SBQQ__Number__c'];

        /* Inventory warning 
        if (
            estAvailableQty < 0 &&
            warehouseNumber &&
            warehouseNumber !== '3099' &&
            itemCategory !== 'Individual Spec') {
            warnings.push(
                `Line ${lineNumber}: Insufficient inventory at the selected warehouse.`
            );
        }*/

        /* Final Unit Price cannot be zero */
        if (finalUnitPrice === 0) {
            line.record["QL_Validation__c"] = true;
            errors.push(
                `Line ${lineNumber}: Final Unit Price cannot be 0.`
            );
        }

    });


    /****************************5.validate Available inventory**************************/
    var productIds = [];

    lines.forEach(function (line) {
        if (line.record['SBQQ__Product__c'] && line.record['Item_Category__c'] === 'Stock Order') {
            productIds.push(line.record['SBQQ__Product__c']);
        }
    });

    if (productIds.length) {
        console.log('Validating available quantity for products:', productIds);

        var idList = "('" + productIds.join("','") + "')";

        return conn
            .query(
                'SELECT Id, Available_Qty__c ' +
                'FROM Product2 ' +
                'WHERE Id IN ' + idList + 'AND Available_Qty__c != NULL'
            )
            .then(function (results) {
                console.log('Product query results:', results);
                if (results.totalSize) {
                    console.log('Processing available quantity validation...');
                    var productQtyMap = {};
                    results.records.forEach(function (record) {
                        productQtyMap[record.Id] = record.Available_Qty__c;
                    });

                    console.log('Product quantity map:', productQtyMap);
                    lines.forEach(function (line) {
                        console.log('Checking line for available quantity validation:', line);
                        if (line.record['Item_Category__c'] === 'Stock Order') {

                            var productId = line.record['SBQQ__Product__c'];
                            var lineQty = line.record['Available_Qty__c'];
                            var prodQty = productQtyMap[productId];
                            var lineNo = line.record['SBQQ__Number__c'];

                            console.log('Line', lineNo, 'ProductId:', productId, 'LineQty:', lineQty, 'ProdQty:', prodQty);

                            if (
                                prodQty !== undefined && lineQty !== null &&
                                lineQty !== prodQty
                            ) {
                                console.log('Available quantity mismatch on line', lineNo, '- marking for validation.');
                                line.record["QL_Validation__c"] = true;
                                errors.push(
                                    `Line ${lineNo}: Available Quantity is changed.Please add line again to get updated quantity.`
                                );
                            }
                        }
                    });
                }
                return errors;
            })
            .catch(function (err) {
                console.error('Error querying products for available quantity validation:', err);
                errors.push(err.message || 'Error validating available quantity.');
                return errors;
            });
    }
    else {
        return Promise.resolve(errors);
    }



    return errors;

}

function highlightValidationErrors(lines) {
    console.log('Highlighting validation errors on UI...');

    try {

        // Get all rendered QLE rows
        const rows = document
            .querySelector('sb-page-container').shadowRoot
            .querySelector('sb-line-editor').shadowRoot
            .querySelector('sb-le-group-layout').shadowRoot
            .querySelector('sb-le-group').shadowRoot
            .querySelector('sf-standard-table').shadowRoot
            .querySelectorAll('sf-le-table-row');

        rows.forEach(row => {

            const uiData = row.__data.uiData;

            if (!uiData) {
                return;
            }

            // UI row values
            const uiMaterialNumber = uiData.Material_Number__c;
            const uiLineNumber = String(uiData.lineNumber);

            // Match with QCP quote line
            const matchedLine = lines.find(line => {

                return (
                    line.record["Material_Number__c"] === uiMaterialNumber &&
                    String(line.record["SBQQ__Number__c"]) === uiLineNumber
                );
            });

            // If validation failed -> highlight row
            if (
                matchedLine &&
                matchedLine.record["QL_Validation__c"] === true
            ) {

                row.style.backgroundColor = '#ffe5e5';
                row.style.borderLeft = '4px solid red';
            }
            else{
                row.style.backgroundColor = '';
                row.style.borderLeft = '';
            }
            

        });

    } catch (error) {

        console.log('highlightValidationErrors Error', error);
    }
}



function updatingPriceUsingPriceMatrixV2(quote, lines, conn) {
 /*   let quoteData;

return fetchQuoteData(quote, conn)
    .then(function (quoteResult) {
        quoteData = quoteResult;   
        return fetchProducts(lines, conn);
    })
    .then(function (productData) {
        return fetchPricingMatrix(quoteData, lines, productData, conn);
    })
    .then(function (matrixData) {
        applyPricingRules(quoteData, lines, matrixData);
        return Promise.resolve();
    });
  const quoteData = {};
    return fetchQuoteData(quote, conn)
  
        .then(quoteData => {
            quoteData = quoteData;
            return fetchProducts(lines, conn)
        })
        .then(productData => {
            return fetchPricingMatrix(quoteData, lines, productData, conn);
        })
        .then(matrixData => {
            applyPricingRules(quoteData, lines, matrixData);
            return Promise.resolve();
        });*/


}
function fetchcostdata(lines, conn, productData) {
    console.log('Fetching cost data...');  

    const productIds = Object.keys(productData.productMap); 
    const prodList = "('" + productIds.join("','") + "')";
    let query ='SELECT Id,APTS_Cost__c,APTS_Product_Name__c FROM APTS_AllCost__c WHERE APTS_Invalid__c = false AND APTS_Valid_From_Date__c <= TODAY AND APTS_Valid_Until_Date__c >= TODAY AND APTS_Product_Name__c IN' + prodList;

    return conn.query(query)
        .then(function (result) {
            console.log('Fetched cost data query result:', result);
            const costMap = {};
            result.records.forEach(function (rec) {
                costMap[rec.APTS_Product_Name__c] = rec.APTS_Cost__c;
            });

            lines.forEach(function (line) {
                const productId = line.record['SBQQ__Product__c'];
                console.log('Updating cost for line with ProductId:', productId);
                console.log('Cost Map:', costMap[productId]);
                if (productId && costMap[productId] !== undefined) {
                    line.record['Prod_Cost__c'] = costMap[productId];
                }
            });
        })
        .catch(function (err) {
            console.error('Error querying cost data:', err);
            return Promise.resolve();
        });
}

function fetchlistpricedata(lines, conn, productData, quoteCreatedDate) {
    console.log('Fetching list price data...');

    const productIds = Object.keys(productData.productMap);
    const prodList = "('" + productIds.join("','") + "')";
    let query = 'SELECT Id,List_Price__c,Product__c,SAP_Material_Number__c,Valid_From__c,Valid_Till__c FROM All_List_Price__c WHERE Valid_From__c <= ' + quoteCreatedDate + ' AND Valid_Till__c >= ' + quoteCreatedDate + ' AND Product__c IN' + prodList;
    console.log('List price query:', query);
    return conn.query(query)
        .then(function (result) {
            console.log('Fetched list price data query result:', result);
            const listPriceMap = {};

            result.records.forEach(function (rec) {
                listPriceMap[rec.Product__c] = rec.List_Price__c;
            });

            console.log('List Price Map:', listPriceMap);
            lines.forEach(function (line) {
                const productId = line.record['SBQQ__Product__c'];
                if ( productId && listPriceMap[productId] != null ) {
                     console.log('Updating List Price for line:', line.record['SBQQ__Number__c'], 'Price:', listPriceMap[productId] );
                    line.record['SBQQ__ListPrice__c'] =  listPriceMap[productId];
                }
            });

            return Promise.resolve();
        })
        .catch(function (err) {
            console.error('Error querying list price data:', err);
            return Promise.resolve();
        });
}

function fetchAndApplyPricingMatrixNetprices(quoteRec, lines, productData, conn) {
    console.log('fetchAndApplyPricingMatrixNetprices:');


    const productIds = Object.keys(productData.productMap);
    const childaccid = [quoteRec.SBQQ__Account__c];
    const parentaccid = [quoteRec.SBQQ__Account__r.ParentId];
    const quoteCreatedDate = [quoteRec.Quote_Created_Date__c];


    const childaccids = "('" + childaccid.join("','") + "')";
    const parentaccids = "('" + parentaccid.join("','") + "')";
    const prodList = "('" + productIds.join("','") + "')";
    
    let query =
        'SELECT Id, Customer_Account__c,Parent_Account__c,Product__c,Product_Category_CIT__c,Product_Sub_Category__c,Product_Catalog__c,NET_Price__c,Product_Discount__c,Product_Sub_Category_Discount__c,Product_Category_Discount__c FROM Pricing_Matrix__c WHERE NET_Price__c !=null AND Valid_From__c <= ' + quoteCreatedDate + ' AND Valid_Till__c >= ' + quoteCreatedDate +  ' AND (Product__c IN' + prodList;
    query += ') AND ( Customer_Account__c IN ' + childaccids + ' OR Parent_Account__c IN ' + parentaccids + ' )';
    console.log('Pricing Matrix Query for net price records:', query);
    return conn.query(query)
        .then(function (result) {
            console.log('fetchAndApplyPricingMatrixNetprices query result:', result);
            const customerNetPriceMap = {};
            const parentNetPriceMap = {};
            result.records.forEach(function (rec) {
                if (rec.Customer_Account__c) {
                    customerNetPriceMap[rec.Product__c] = rec.NET_Price__c;
                }
                if (rec.Parent_Account__c) {
                    parentNetPriceMap[rec.Product__c] = rec.NET_Price__c;
                }
            });

            console.log('Customer Net Price Map:', customerNetPriceMap, '===   Parent Net Price Map:', parentNetPriceMap);
            lines.forEach(function (line) {
                const productId = line.record['SBQQ__Product__c'];
                let netpricevalue = null;
                if ( productId && customerNetPriceMap[productId] != null ) {
                    netpricevalue = customerNetPriceMap[productId];
                }
                else if ( productId && parentNetPriceMap[productId] != null ) {
                    netpricevalue = parentNetPriceMap[productId];
                }
                if(netpricevalue != null){
                line.record['SBQQ__SpecialPrice__c'] = netpricevalue;
                line.record['SBQQ__SpecialPriceType__c'] = 'Custom';
                line.record['SBQQ__RegularPrice__c'] = netpricevalue;
                 line.record['IsCalculated__c'] = true;
                }
            });


            return Promise.resolve();
        })
        .catch(function (err) {
            console.error('Error on fetchAndApplyPricingMatrixNetprices:', err);
            return Promise.resolve();
        });
}



function applyPricingRules(quote, lines, data,itemCategorymassupdate,multiplierMassUpdate) {
 console.log('Applying pricing rules using price matrix...'+ 'with sepecial price add');
 console.log('Quote:', quote);
 console.log('Pricing matrix data:', data);
    const productMap = data.productMap;
    const matrixList = data.matrixList;
   
    

    lines.forEach(line => {
        var isselectedonui = getlineuidetails(line);
        console.log('Line', line.record['SBQQ__Number__c'], 'selected on UI:', isselectedonui);
       /* console.log(' line.record Base_Price_Override__c:', line.record['Base_Price_Override__c']);
         if(line.record['Base_Price_Override__c'] != null && line.record['Base_Price_Override__c'] > 0){ 
            console.log(`Line ${line.record['SBQQ__Number__c']} - Applying Base Price Override:`, line.record['Base_Price_Override__c']);
         line.record['SBQQ__NetPrice__c'] = line.record['Base_Price_Override__c'];
         }*/
        console.log('Processing line for pricing matrix:', line.record['SBQQ__Number__c'], 'IsCalculated:', line.record['IsCalculated__c']);
        if(line.record['IsCalculated__c'] === false){
        const prod = productMap[line.record['SBQQ__Product__c']];
       
        if (!prod) return;

        /*let netPrice = null;
        let discount = null;

       for (const pm of matrixList) {
            console.log('Checking category discount for:', prod.APTS_Mat_Grp_1_CIT__c, pm.Product_Category_CIT__c);
            console.log('Checking catalog discount for:', prod.APTS_Mat_Grp_2_Catlg__c, pm.Product_Catalog__c);
            console.log('Checking sub-category discount for:', prod.APTS_Mat_Grp_3_Catgr_CD__c, pm.Product_Sub_Category__c);
            if (pm.Product__c === line.record['SBQQ__Product__c']) {
                console.log('inside product match for pricing matrix:', pm);
                if (pm.Customer_Account__c === quote.SBQQ__Account__c && pm.NET_Price__c) {
                    netPrice = pm.NET_Price__c;
                    break;
                }
                else if (pm.Parent_Account__c === quote.SBQQ__Account__r.ParentId && pm.NET_Price__c) {
                    netPrice = pm.NET_Price__c;
                    break;
                }
                else if (pm.Customer_Account__c === quote.SBQQ__Account__c && pm.Product_Discount__c) {
                    discount = pm.Product_Discount__c;
                    break;
                }
                else if (pm.Parent_Account__c === quote.SBQQ__Account__r.ParentId && pm.Product_Discount__c) {
                    discount = pm.Product_Discount__c;
                    break;
                }

            } else if (
                pm.Product_Sub_Category__c === prod.APTS_Mat_Grp_3_Catgr_CD__c &&
                pm.Product_Sub_Category_Discount__c
            ) {
                console.log('inside sub-category match for pricing matrix:', pm);
                discount = pm.Product_Sub_Category_Discount__c;
                break;
                
            }
            else if (
                pm.Product_Category_CIT__c === prod.APTS_Mat_Grp_1_CIT__c &&
                pm.Product_Catalog__c == prod.APTS_Mat_Grp_2_Catlg__c &&
                pm.Product_Category_Discount__c
            ) {
                console.log('inside category-catalog match for pricing matrix:', pm);
                discount = pm.Product_Category_Discount__c;
                break;
            }
        };*/
            let selectedPricingRule = null;
            let bestPriority = 99;

            for (const pm of matrixList) {

                let result = matchPricing(pm, line, prod, quote);
                if (result && result.priority < bestPriority) {
                    selectedPricingRule = result;
                    bestPriority = result.priority;
                }

            }

       // console.log(`Line ${line.record['SBQQ__Number__c']} - Net Price:`, netPrice, 'Discount:', discount);
        console.log(`Line ${line.record['SBQQ__Number__c']} - Selected Pricing matrix Rule:`, selectedPricingRule);
        if (selectedPricingRule) {

            if (selectedPricingRule.isNetPrice) {
                line.record['SBQQ__SpecialPrice__c'] = selectedPricingRule.value;
                line.record['SBQQ__SpecialPriceType__c'] = 'Custom';
                line.record['SBQQ__RegularPrice__c'] = selectedPricingRule.value;
            } else {
                const spprice =
                    line.record['SBQQ__ListPrice__c'] *
                    (selectedPricingRule.value / 100);

                line.record['SBQQ__SpecialPrice__c'] = spprice;
                line.record['SBQQ__SpecialPriceType__c'] = 'Custom';
                line.record['Multiplier__c'] = selectedPricingRule.value;
            }

            line.record['IsCalculated__c'] = true;
        }

        

       /* if (netPrice !== null) {
            //line.record['SBQQ__CustomerPrice__c'] = netPrice;
            //line.record['SBQQ__PricingMethod__c'] = 'Custom';
            line.record['SBQQ__SpecialPrice__c'] = netPrice;
            line.record['SBQQ__SpecialPriceType__c'] = 'Custom';
            line.record['SBQQ__RegularPrice__c'] = netPrice;
            line.record['IsCalculated__c'] = true;
        } else if (discount !== null) {
            var spprice = line.record['SBQQ__ListPrice__c'] * (discount / 100);
            line.record['SBQQ__SpecialPrice__c'] = spprice;
            line.record['SBQQ__SpecialPriceType__c'] = 'Custom';
            line.record['Multiplier__c'] = discount;
            line.record['IsCalculated__c'] = true;
        }*/
     }
    if(multiplierMassUpdate >0  && line.record['Multiplier__c'] != multiplierMassUpdate && isselectedonui){
        console.log(`Line ${line.record['SBQQ__Number__c']} - Applying Quote Level Multiplier:`, multiplierMassUpdate);
        line.record['Multiplier__c'] = multiplierMassUpdate;
    }
    

    if(itemCategorymassupdate && line.record['Item_Category__c'] != itemCategorymassupdate && isselectedonui){
        console.log(`Line ${line.record['SBQQ__Number__c']} - Applying Quote Level Item Category:`, itemCategorymassupdate);
        line.record['Item_Category__c'] = itemCategorymassupdate;
    }
     
    if(line.record['Multiplier__c'] > 0 ){
        console.log(`Line ${line.record['SBQQ__Number__c']} - Applying Multiplier:`, line.record['Multiplier__c']);
        line.record['SBQQ__SpecialPrice__c'] = line.record['SBQQ__ListPrice__c'] * (line.record['Multiplier__c'] / 100);
        line.record['SBQQ__SpecialPriceType__c'] = 'Custom';
    }
    
      line.record['Total_Weight_lb__c'] = line.record['SBQQ__Quantity__c'] * line.record['Weight_lb__c'];
    
    });
}

function getlineuidetails(line) {
    console.log('getlineuidetails...');

    try {

        // Get all rendered QLE rows
        const rows = document
            .querySelector('sb-page-container').shadowRoot
            .querySelector('sb-line-editor').shadowRoot
            .querySelector('sb-le-group-layout').shadowRoot
            .querySelector('sb-le-group').shadowRoot
            .querySelector('sf-standard-table').shadowRoot
            .querySelectorAll('sf-le-table-row');

        for (const row of rows) {

            const uiData = row.__data.uiData;

            if (!uiData) {
                return;
            }

            // UI row values
            const uiMaterialNumber = uiData.Material_Number__c;
            const uiLineNumber = String(uiData.lineNumber);

            console.log('Checking UI row for line number:', uiLineNumber, 'material number:', uiMaterialNumber);
            console.log('Comparing with line record - line number:', line.record['SBQQ__Number__c'], 'material number:', line.record["Material_Number__c"]);
            console.log('UI row selected:', uiData.lineModel.selected);

            if (
                line.record["Material_Number__c"] === uiMaterialNumber &&
                String(line.record["SBQQ__Number__c"]) === uiLineNumber 
                
            ) {
                
               return uiData.lineModel.selected;
            }
                
            

        }

    } catch (error) {

        console.log('getlineuidetails Error', error);
    }
}


function matchPricing(pm, line, prod, quote) {

    
    const custId   = quote.SBQQ__Account__c;
    const parentId = quote.SBQQ__Account__r.ParentId;
    const prodId   = line.record['SBQQ__Product__c'];

    console.log('Matching pricing matrix entry:', pm.Customer_Account__c, pm.Parent_Account__c, pm.Product__c,pm.Product_Sub_Category__c,pm.Product_Category_CIT__c,pm.Product_Catalog__c);
    console.log('Against quote customer:', custId, 'parent:', parentId, 'product:', prodId, 'sub-category:', prod.APTS_Mat_Grp_3_Catgr_CD__c, 'category:', prod.APTS_Mat_Grp_1_CIT__c, 'catalog:', prod.APTS_Mat_Grp_2_Catlg__cs);

    // 1️⃣ Customer + Product + NET
    if (pm.Customer_Account__c === custId &&
        pm.Product__c === prodId &&
        pm.NET_Price__c)
        return { priority: 1, value: pm.NET_Price__c, isNetPrice: true };

    // 2️⃣ Parent + Product + NET
    if (pm.Parent_Account__c === parentId &&
        pm.Product__c === prodId &&
        pm.NET_Price__c)
        return { priority: 2, value: pm.NET_Price__c, isNetPrice: true };

    // 3️⃣ Customer + Product + Discount
    if (pm.Customer_Account__c === custId &&
        pm.Product__c === prodId &&
        pm.Product_Discount__c)
        return { priority: 3, value: pm.Product_Discount__c, isNetPrice: false };

    // 4️⃣ Parent + Product + Discount
    if (pm.Parent_Account__c === parentId &&
        pm.Product__c === prodId &&
        pm.Product_Discount__c)
        return { priority: 4, value: pm.Product_Discount__c, isNetPrice: false };

    // 5️⃣ Customer + Sub-Category
    if (pm.Customer_Account__c === custId &&
        pm.Product_Sub_Category__c === prod.APTS_Mat_Grp_3_Catgr_CD__c &&
        pm.Product_Sub_Category_Discount__c)
        return { priority: 5, value: pm.Product_Sub_Category_Discount__c, isNetPrice: false };

    // 6️⃣ Parent + Sub-Category
    if (pm.Parent_Account__c === parentId &&
        pm.Product_Sub_Category__c === prod.APTS_Mat_Grp_3_Catgr_CD__c &&
        pm.Product_Sub_Category_Discount__c)
        return { priority: 6, value: pm.Product_Sub_Category_Discount__c, isNetPrice: false };

    // 7️⃣ Customer + Category + Catalog
    if (pm.Customer_Account__c === custId &&
        pm.Product_Category_CIT__c === prod.APTS_Mat_Grp_1_CIT__c &&
        pm.Product_Catalog__c === prod.APTS_Mat_Grp_2_Catlg__c &&
        pm.Product_Category_Discount__c)
        return { priority: 7, value: pm.Product_Category_Discount__c, isNetPrice: false };

    // 8️⃣ Parent + Category + Catalog
    if (pm.Parent_Account__c === parentId &&
        pm.Product_Category_CIT__c === prod.APTS_Mat_Grp_1_CIT__c &&
        pm.Product_Catalog__c === prod.APTS_Mat_Grp_2_Catlg__c &&
        pm.Product_Category_Discount__c)
        return { priority: 8, value: pm.Product_Category_Discount__c, isNetPrice: false };

    return null;
}


function fetchProducts(lines, conn) {

    var productIds = [];

    lines.forEach(line => {
        if (line.record['SBQQ__Product__c']) {
            productIds.push(line.record['SBQQ__Product__c']);
        }
    });

    if (!productIds.length) {
        return Promise.resolve({
            productMap: {},
            categorySet: [],
            subCategorySet: []
        });
    }

    var idList = "('" + productIds.join("','") + "')";

    return conn.query(
        'SELECT Id,APTS_Mat_Grp_1_CIT__c,APTS_Mat_Grp_2_Catlg__c,APTS_Mat_Grp_3_Catgr_CD__c FROM Product2 WHERE Id IN' + idList
    ).then(function (result) {
        console.log('Fetched products data query:', result);

        const productMap = {};
        const categorySet = [];
        const subCategorySet = [];

        result.records.forEach(p => {
            productMap[p.Id] = p;

            if (p.APTS_Mat_Grp_1_CIT__c) {
                categorySet.push(p.APTS_Mat_Grp_1_CIT__c);
            }
            if (p.APTS_Mat_Grp_3_Catgr_CD__c) {
                subCategorySet.push(p.APTS_Mat_Grp_3_Catgr_CD__c);
            }
        });

        return Promise.resolve({
            productMap,
            categorySet: [...new Set(categorySet)],
            subCategorySet: [...new Set(subCategorySet)]
        });
    })
        .catch(function (err) {
            console.error('Error querying products for price matrix:', err);
            return Promise.resolve({
                productMap: {},
                categorySet: [],
                subCategorySet: []
            });
        });
}

function fetchPricingMatrix(quoteRec, lines, productData, conn) {
    console.log('Fetching pricing matrix for products:', Object.keys(productData.productMap));
    console.log("Quote Record:", quoteRec);


    const productIds = Object.keys(productData.productMap);
    const childaccid = [quoteRec.SBQQ__Account__c];
    const parentaccid = [quoteRec.SBQQ__Account__r.ParentId];
    if (!productIds.length) {
        return Promise.resolve({
            productMap: productData.productMap,
            matrixList: []
        });
    }

    const childaccids = "('" + childaccid.join("','") + "')";
    const parentaccids = "('" + parentaccid.join("','") + "')";
    const prodList = "('" + productIds.join("','") + "')";
    const catList = productData.categorySet.length
        ? "('" + productData.categorySet.join("','") + "')"
        : null;
    const subCatList = productData.subCategorySet.length
        ? "('" + productData.subCategorySet.join("','") + "')"
        : null;

    let query =
        'SELECT Id, Customer_Account__c,Parent_Account__c,Product__c,Product_Category_CIT__c,Product_Sub_Category__c,Product_Catalog__c,NET_Price__c,Product_Discount__c,Product_Sub_Category_Discount__c,Product_Category_Discount__c FROM Pricing_Matrix__c WHERE Active__c = true AND Valid_Till__c >= TODAY AND (Product__c IN' + prodList;

    if (subCatList) query += 'OR Product_Sub_Category__c IN' + subCatList;
    if (catList) query += ' OR Product_Category_CIT__c IN' + catList;

    query += ') AND ( Customer_Account__c IN ' + childaccids + ' OR Parent_Account__c IN ' + parentaccids + ' )';
    console.log('Pricing Matrix Query:', query);
    return conn.query(query)
        .then(function (result) {
            console.log('Fetched pricing matrix query result:', result);
            return Promise.resolve({
                productMap: productData.productMap,
                matrixList: result.records
            });
        })
        .catch(function (err) {
            console.error('Error querying pricing matrix:', err);
            return Promise.resolve({
                productMap: productData.productMap,
                matrixList: []
            });
        });
}

function fetchQuoteData(quote, conn) {
    

    var idList = "('" + quote.Id + "')";

    return conn.query(
        'SELECT Id, SBQQ__Account__c, SBQQ__Account__r.ParentId,Project__c,Item_Category_Mass_Update__c,Multiplier_Mass_Update__c,Quote_Created_Date__c ' +
        'FROM SBQQ__Quote__c ' +
        'WHERE Id IN ' + idList
    ).then(function (result) {

        if (!result.totalSize) {
            return {};
        }

        return Promise.resolve(result.records[0]);
    })
        .catch(function (err) {
            console.error('Error querying quote data:', err);
            return {};
        });
}

function fetchProjectPricingMatrix(quoteRec, lines, productData, conn) {
    console.log('Fetching Project pricing matrix for products:', Object.keys(productData.productMap));

    const productIds = Object.keys(productData.productMap);
    const Distributoraccid = [quoteRec.SBQQ__Account__c];
    const projectid = [quoteRec.Project__c];
    if (!productIds.length) {
        return Promise.resolve({
            productMap: productData.productMap,
            matrixList: []
        });
    }

   // const Distributoraccid = "('" + Distributoraccid.join("','") + "')";
   // const projectid = "('" + projectid.join("','") + "')";
    const prodList = "('" + productIds.join("','") + "')";
    const catList = productData.categorySet.length
        ? "('" + productData.categorySet.join("','") + "')"
        : null;
    const subCatList = productData.subCategorySet.length
        ? "('" + productData.subCategorySet.join("','") + "')"
        : null;

    let query =
        'SELECT Id,Project__c, Distributor_Account__c,Product__c,Product_Category_CIT__c,Product_Sub_Category__c,Product_Catalog__c,NET_Price__c,Discount__c,Product_Sub_Category_Discount__c,Product_Category_Discount__c FROM Project_Pricing_Matrix__c WHERE Active__c = true  AND (Product__c IN' + prodList;

    if (subCatList) query += 'OR Product_Sub_Category__c IN' + subCatList;
    if (catList) query += ' OR Product_Category_CIT__c IN' + catList;

    query += ') AND  Distributor_Account__c IN ' + "('" + Distributoraccid.join("','") + "')" + ' AND Project__c IN ' + "('" + projectid.join("','") + "')";
    console.log('===>>Project Pricing Matrix Query:', query);
    return conn.query(query)
        .then(function (result) {
            console.log('Fetched project pricing matrix query result:', result);
            return Promise.resolve({
                productMap: productData.productMap,
                matrixList: result.records
            });
        })
        .catch(function (err) {
            console.error('Error querying project pricing matrix:', err);
            return Promise.resolve({
                productMap: productData.productMap,
                matrixList: []
            });
        });
}



function applyProjectPricingRules(quote, lines, data) {
 console.log('======>Applying Project pricing rules using project price matrix...');
 console.log('===>Project Pricing matrix data:', data);
    const productMap = data.productMap;
    const matrixList = data.matrixList;

    lines.forEach(line => {

      console.log('========>line record for matching project pricing:', line.record['SBQQ__Number__c']);
        if(line.record['IsCalculated__c'] === false){
        const prod = productMap[line.record['SBQQ__Product__c']];
       
        if (!prod) return;

            let selectedPricingRule = null;
            let bestPriority = 99;

            for (const pm of matrixList) {

                let result = matchprojectPricing(pm, line, prod, quote);
                if (result && result.priority < bestPriority) {
                    selectedPricingRule = result;
                    bestPriority = result.priority;
                }

            }

        console.log(`=====> Line ${line.record['SBQQ__Number__c']} - Selected Project Pricing Rule:`, selectedPricingRule);
        if (selectedPricingRule) {

            if (selectedPricingRule.isNetPrice) {
                line.record['SBQQ__SpecialPrice__c'] = selectedPricingRule.value;
                line.record['SBQQ__SpecialPriceType__c'] = 'Custom';
                line.record['SBQQ__RegularPrice__c'] = selectedPricingRule.value;
            } else {
                const spprice =line.record['SBQQ__ListPrice__c'] * (selectedPricingRule.value / 100);
                line.record['SBQQ__SpecialPrice__c'] = spprice;
                line.record['SBQQ__SpecialPriceType__c'] = 'Custom';
                line.record['Multiplier__c'] = selectedPricingRule.value;
            }

            line.record['IsCalculated__c'] = true;
        }

     }

    });
}

function matchprojectPricing(pm, line, prod, quote) {

    
    const custId   = quote.SBQQ__Account__c;
    //const parentId = quote.Project__c;
    const prodId   = line.record['SBQQ__Product__c'];
    
    
    console.log('========>Matching project pricing matrix entry:', pm.Distributor_Account__c, pm.Parent_Account__c, pm.Product__c,pm.Product_Sub_Category__c,pm.Product_Category_CIT__c,pm.Product_Catalog__c);
    console.log('========>Against quote customer:', custId, 'product:', prodId, 'sub-category:', prod.APTS_Mat_Grp_3_Catgr_CD__c, 'category:', prod.APTS_Mat_Grp_1_CIT__c, 'catalog:', prod.APTS_Mat_Grp_2_Catlg__cs);

    // 1️⃣ Distributor + Product + NET
    if (pm.Distributor_Account__c === custId &&
        pm.Product__c === prodId &&
        pm.NET_Price__c)
        return { priority: 1, value: pm.NET_Price__c, isNetPrice: true };

    // 2️⃣ Distributor + Product + Discount
     if (pm.Distributor_Account__c === custId &&
        pm.Product__c === prodId &&
        pm.Discount__c)
        return { priority: 2, value: pm.Discount__c, isNetPrice: false };

    // 3️⃣ Distributor + Sub-Category
    if (pm.Distributor_Account__c === custId &&
        pm.Product_Sub_Category__c === prod.APTS_Mat_Grp_3_Catgr_CD__c &&
        pm.Product_Sub_Category_Discount__c)
        return { priority: 3, value: pm.Product_Sub_Category_Discount__c, isNetPrice: false };
   

    // 4️⃣ Distributor + Category + Catalog
    if (pm.Distributor_Account__c === custId &&
        pm.Product_Category_CIT__c === prod.APTS_Mat_Grp_1_CIT__c &&
        pm.Product_Catalog__c === prod.APTS_Mat_Grp_2_Catlg__c &&
        pm.Product_Category_Discount__c)
        return { priority: 4, value: pm.Product_Category_Discount__c, isNetPrice: false };

    return null;
}


