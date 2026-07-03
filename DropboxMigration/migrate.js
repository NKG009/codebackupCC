//uiinterface 
log('🚀 Migration started...');

process.on('uncaughtException', (err) => {
    console.error('❌ Uncaught Exception:', err);
});

process.on('unhandledRejection', (err) => {
    console.error('❌ Unhandled Rejection:', err);
});



async function getRuntimeConfig() {
    const readline = require('readline');

    const rl = readline.createInterface({
        input: process.stdin,
        output: process.stdout
    });

    const ask = (q) => new Promise(res => rl.question(q, res));

    const DROPBOX_TOKEN = await ask('Enter Dropbox Access Token: ');
    const SF_ACCESS_TOKEN = await ask('Enter Salesforce Access Token: ');
    const SF_INSTANCE_URL = await ask('Enter Salesforce Instance URL: ');

    rl.close();

    return {
        DROPBOX_TOKEN: DROPBOX_TOKEN.trim(),
        SF_ACCESS_TOKEN: SF_ACCESS_TOKEN.trim(),
        SF_INSTANCE_URL: SF_INSTANCE_URL.trim()
    };
}


const axios = require('axios');
const { Dropbox } = require('dropbox');
//const pLimit = require('p-limit').default;
const pLimit = require('p-limit');
const fs = require('fs-extra');



// ================= CONFIG =================
//const DROPBOX_TOKEN='sl.u.AGeY3aKGnx3ArrfqHpL9CfLp9nC75pYp-vhGRiiyTcld71vcAZT-BBt1Bv-cB1zR0HzvtoPsza8nx1kNki5u1WzUW__M-tNnG_OVMDxwwgWelP9Ta5FdccoPyDrO4uYbZKWDV7F6G2PwDg7Id4hkn1eOS14cmeUE4DvDz_dt7wyqcOPxm_10pdI2cUh43PGhHzs6YniqHjWjJlHLQnkU6fRVm5loUzFtRBxuU8z7LwTNEAoLolyW1em8ttkE2LWcP0odG2iWIWZjoZ8aF1J4KEwltEUWdCVuF3WVRq1OfFxKvpfOJ3YMEF3N__XuFdeR1LWKPoogJlsQhrPvZGbgI9uoxqjlReRXj8KW2T-3DsfsxjEwGFNyU_XCKWxftOHUaI8AGyDvv9HZFJFld_xNC5jJrdnLd7xjIMB1ized-i5eMMxfIxj9YtCyk4Fo57uUMwZE-a6msJgJ7Nkp_HOPviKUmwzxJaMc51llc8bUj0UunZWPGtJ2EbP3Ekw-UNGePbc7lL2mCGf6zix1StmD040A_gnHDnMvy5i3KqXpCAUOSTANsAIgQ1sHXLNA-TOlOVoihVt0MpBpFjYxb69EXSBF62Sc4fCYNVtiQAr5z3fE97DdABMaLvcuI2MJ7UofNezNx13drUdsZYuAnZOK8lQypTuNLJ6ey04H-fT0yHCx7K3Xz3w_QwSE4SswqczoivTy1hYWYkK3RpjGCUN1Pu_G1UQCBCTN_EkJAZYzUPsGUVQuazBEhopqGI-THG1Ps0OTrq9dVRsjTIoOK9OoUBAN4d2n6qrM28Z1VUvdZ4uhgpRRO8-ssZBE87Ewdi5etpG2uavLqIM-1PK_sobAV6zE_XWly0rM2w4w190_HzVvLsV4mhwTy8kkwtPuqWF4KuezH8VGf4suLk5LPbksqQnea7ldDdrSFdmEJwHXgJ5shhp1sxaj9RYnC8tQg9K6S1wHvGSZ-PNaM8pGx7OSroWL9rm1JgRl2af8qOQ4Y-KcPPY5J37KYTUpxbsQx3fc_tfCmcGNs_rkkw_uQwf-7IJiHmiyB3n3lORL1eioPw6qzBMmsbihWBrq0vpD_KRdKLRkGX7mGQDaO2l81Qu4mt--UNLhGol6aHloThJSHQ8hJ9r0L_YHu66uuy8kycuJ3uku0NwF5djZWzLyXcmzsW1N1PV3cJ1_IYAGB9wukUafTYQB8KoGPYBVc7J7Q2JZ-fH-0uftBnmeNY8q1esgonuF0iA7b7ajCCoYGc1NpwEPD-9VU_Y-CzbP_rDJ_HnzhonbmBhfjg0dGR4WSyXfUk_SRV06lP--878o2vSSGCFivg';
//const SF_ACCESS_TOKEN = '00DcU000005aMIT!AQEAQI4CC0.0ZuNkaTdh51SZRRF8av4Kut6erooeRkNd0jyxeAlBgF_DgAYJVzud8RcrkrANBCHXxQynt_WQvMWC2RIrf16N';
//const SF_INSTANCE_URL = 'https://brabo--full.sandbox.my.salesforce.com';

let DROPBOX_TOKEN;
let SF_ACCESS_TOKEN;
let SF_INSTANCE_URL;
let dbx;
const CHUNK_SIZE = 5 * 1024 * 1024; // 5MB
const CONCURRENCY = 1; // parallel files
const RETRY_COUNT = 3;

// ==========================================
const report = [];
//const dbx = new Dropbox({ accessToken: DROPBOX_TOKEN });
const limit = pLimit(CONCURRENCY);

// ---------------- LOGGING -----------------
function log(message) {
    console.log(`[${new Date().toISOString()}] ${message}`);
}

// ---------------- RETRY -------------------
async function retry(fn, retries = RETRY_COUNT) {
    for (let i = 0; i < retries; i++) {
        try {
            return await fn();
        } catch (err) {
            if (i === retries - 1) throw err;
            log(`Retrying... (${i + 1})`);
        }
    }
}

const XLSX = require('xlsx');
const path = require('path');
const REPORT_FILE = path.join(process.cwd(), 'migration_report.xlsx');
// const REPORT_FILE = 'migration_report.xlsx';

function updateExcelReport(folderSummary) {
    try {
        let workbook;
        let worksheet;

        if (fs.existsSync(REPORT_FILE)) {
            workbook = XLSX.readFile(REPORT_FILE);
            worksheet = workbook.Sheets['Migration Report'];

            const existingData = XLSX.utils.sheet_to_json(worksheet);

            const updatedData = [...existingData, folderSummary];

            const newSheet = XLSX.utils.json_to_sheet(updatedData);

            workbook.Sheets['Migration Report'] = newSheet;
        } else {
            workbook = XLSX.utils.book_new();
            worksheet = XLSX.utils.json_to_sheet([folderSummary]);

            XLSX.utils.book_append_sheet(workbook, worksheet, 'Migration Report');
        }

        XLSX.writeFile(workbook, REPORT_FILE);

        log(`📊 Excel updated: ${folderSummary.folderName}`);

    } catch (err) {
        console.error('❌ Excel Update Error:', err.message);
    }
}

const MAX_RUNTIME = 3.5 * 60 * 60 * 1000; // 3.5 hours
let stopRequested = false;

setTimeout(() => {
    log('⏰ Max runtime reached. Will stop after current file...');
    stopRequested = true;
}, MAX_RUNTIME);

// ----------- LIST FILES (STREAM SAFE) -----
const visited = new Set();

async function listFiles(path = '') {
    if (visited.has(path)) {
        log(`⚠️ Skipping already visited: ${path}`);
        return [];
    }

    visited.add(path);

    log(`📂 Listing path: ${path}`);

    let files = [];

    let response = await dbx.filesListFolder({ path });

    async function process(entries) {
        for (const entry of entries) {
            if (entry['.tag'] === 'folder') {
                const sub = await listFiles(entry.path_lower);
                files = files.concat(sub);
            } else {
                files.push({
                    name: entry.name,
                    path: entry.path_lower,
                    size: entry.size
                });
            }
        }
    }

    await process(response.result.entries);

    while (response.result.has_more) {
        response = await dbx.filesListFolderContinue({
            cursor: response.result.cursor
        });
        await process(response.result.entries);
    }
    log(`Finished listing files for path: ${path}`);
    return files;
}



// ----------- STREAM DOWNLOAD --------------
const { pipeline } = require('stream');
const { promisify } = require('util');
const streamPipeline = promisify(pipeline);

async function downloadToTemp(file) {
    log('inside downloadToTemp');

    try {
        log(`⬇️ Downloading ${file.name} from ${file.path}`);

        const safeName = file.name.replace(/[<>:"/\\|?*\s]+$/g, '').trim();
        const tempDir = path.join(process.cwd(), 'temp');
        const tempPath = path.join(tempDir, safeName);

        await fs.ensureDir(tempDir);

        const res = await axios({
            url: `https://content.dropboxapi.com/2/files/download`,
            method: 'POST',
            headers: {
                Authorization: `Bearer ${DROPBOX_TOKEN}`,
                'Dropbox-API-Arg': JSON.stringify({ path: file.path }),
                'Content-Type': 'application/octet-stream'
            },
            responseType: 'stream'
        });

        const writer = fs.createWriteStream(tempPath);

        // ✅ THIS is the fix
        await streamPipeline(res.data, writer);

        log(`✅ Downloaded: ${file.name}`);
        return tempPath;

    } catch (err) {
        console.error('❌ DOWNLOAD ERROR:', err.response?.data || err.message);
        throw err;
    }
}
/*async function downloadToTemp(file) {
    log('inside downloadToTemp');
    try {
        log(`⬇️ Downloading ${file.name} from ${file.path}`);

        //const tempPath = `./temp/${file.name}`;
        const safeName = file.name.replace(/[<>:"/\\|?*\s]+$/g, '').trim();
        const tempPath = path.join(process.cwd(), 'temp', safeName);
        //  const tempPath = path.join(process.cwd(), 'temp', file.name);
        const res = await axios({
            url: `https://content.dropboxapi.com/2/files/download`,
            method: 'POST',
            headers: {
                Authorization: `Bearer ${DROPBOX_TOKEN}`,
                'Dropbox-API-Arg': JSON.stringify({
                    path: file.path // keep as is
                }),
                'Content-Type': 'application/octet-stream' // ✅ REQUIRED
            },
            responseType: 'stream'
        });

        await fs.ensureDir('./temp');

        const writer = fs.createWriteStream(tempPath);

        res.data.pipe(writer);

        return new Promise((resolve, reject) => {
            writer.on('finish', () => {
                log(`✅ Downloaded: ${file.name}`);
                resolve(tempPath);
            });
            writer.on('error', reject);
        });

    } catch (err) {
        console.error('❌ DOWNLOAD ERROR:', err.response?.data || err.message);
        throw err;
    }
}*/

// ----------- SF CREATE FILE ---------------
async function createContentVersion(fileName) {
    try {
        log(`📄 Creating ContentVersion for ${fileName}`);

        const res = await axios.post(
            `${SF_INSTANCE_URL}/services/data/v59.0/sobjects/ContentVersion`,
            {
                Title: fileName,
                PathOnClient: fileName,
                Origin: 'H' // ✅ VERY IMPORTANT
            },
            {
                headers: {
                    Authorization: `Bearer ${SF_ACCESS_TOKEN}`,
                    'Content-Type': 'application/json'
                }
            }
        );

        log(`✅ ContentVersion Created: ${res.data.id}`);

        return res.data.id;

    } catch (err) {
        console.error('❌ ContentVersion ERROR:', err.response?.data || err.message);
        throw err;
    }
}

// ----------- CHUNK UPLOAD -----------------
async function uploadFileChunks(filePath, contentVersionId) {
    log(`Uploading chunks for ${filePath} to ContentVersionId: ${contentVersionId}`);
    const stat = await fs.stat(filePath);
    const totalSize = stat.size;

    const stream = fs.createReadStream(filePath, {
        highWaterMark: CHUNK_SIZE
    });

    let start = 0;

    for await (const chunk of stream) {
        const end = start + chunk.length - 1;

        await retry(() =>
            axios.patch(
                `${SF_INSTANCE_URL}/services/data/v59.0/sobjects/ContentVersion/${contentVersionId}/VersionData`,
                chunk,
                {
                    headers: {
                        Authorization: `Bearer ${SF_ACCESS_TOKEN}`,
                        'Content-Type': 'application/octet-stream',
                        'Content-Range': `bytes ${start}-${end}/${totalSize}`
                    }
                }
            )
        );

        log(`Chunk uploaded: ${start}-${end}`);
        start += chunk.length;
    }
}

// ----------- GET RECORD -------------------
async function getAccountId(folderName) {  //get dropbox folder name and query salesforce for matching record  Previous_dropbox_documents__c
    log('inside getAccountId getting Previous_dropbox_documents__c id for folderName: ' + folderName);
    try {
        const query = `SELECT Id FROM Previous_dropbox_documents__c WHERE name = '${folderName}' LIMIT 1`;

        log(`🔍 Running Query: ${query}`);

        const url = `${SF_INSTANCE_URL}/services/data/v59.0/query?q=${encodeURIComponent(query)}`;

        log(`🌐 Calling URL: ${url}`);

        const res = await axios.get(url, {
            headers: { Authorization: `Bearer ${SF_ACCESS_TOKEN}` }
        });

        log(`✅ Query Response: ${JSON.stringify(res.data)}`);

        return res.data.records[0]?.Id || null;

    } catch (err) {
        console.error('❌ getAccountId ERROR:', err.response?.data || err.message);
        throw err;
    }
}
// ----------- GET DOCUMENT ID --------------
async function getContentDocumentId(cvId) {
    log(`Getting ContentDocumentId for ContentVersionId: ${cvId}`);
    const query = `SELECT ContentDocumentId FROM ContentVersion WHERE Id='${cvId}'`;

    const res = await axios.get(
        `${SF_INSTANCE_URL}/services/data/v59.0/query?q=${encodeURIComponent(query)}`,
        {
            headers: { Authorization: `Bearer ${SF_ACCESS_TOKEN}` }
        }
    );

    return res.data.records[0].ContentDocumentId;
}

// ----------- LINK FILE --------------------
async function linkFile(docId, recordId) {
    log(`linkFile: ${docId}, ${recordId}`);
    await axios.post(
        `${SF_INSTANCE_URL}/services/data/v59.0/sobjects/ContentDocumentLink`,
        {
            ContentDocumentId: docId,
            LinkedEntityId: recordId,
            ShareType: 'V'
        },
        {
            headers: { Authorization: `Bearer ${SF_ACCESS_TOKEN}` }
        }
    );
}
function getRootFolder(filePath) {
    const BASE_PATH = '/Brabo benefits/Payroll - Shared/ACTIVE PAYROLL CLIENTS';  ///Brabo benefits/Payroll - Shared/Termed CLIENTS

    // normalize both sides (important!)
    const normalizedFilePath = filePath.toLowerCase();
    const normalizedBase = BASE_PATH.toLowerCase();

    if (!normalizedFilePath.startsWith(normalizedBase)) {
        throw new Error(`❌ Path mismatch: ${filePath}`);
    }

    // remove base path
    const relativePath = filePath.substring(BASE_PATH.length);

    const parts = relativePath.split('/').filter(p => p);

    return parts[0]; // ✅ THIS will now be Folder1
}

function generateSalesforceFileName(file) {
    const BASE_PATH = '/Brabo benefits/Payroll - Shared/ACTIVE PAYROLL CLIENTS';
    const normalizedBase = BASE_PATH.toLowerCase();
    if (!file.path.startsWith(normalizedBase)) {
        throw new Error(`❌ Path mismatch: ${file.path}`);
    }

    // Remove base path
    const relativePath = file.path.substring(BASE_PATH.length);


    log(`📂 Relative path: ${relativePath}`);

    // Split remaining path
    const parts = relativePath.split('/').filter(p => p);

    log(`📂 Path parts: ${parts}`);

    const fileName = parts.pop(); // actual file name

    if (parts.length <= 1) {
        return fileName; // no subfolder
    }

    // Skip root folder (Tim Acton Landscaping Inc)
    const subFolders = parts.slice(1);
    log(`📂 Subfolders for naming: ${subFolders}`);

    return `${subFolders.join('_')}_${file.name}`;
}



async function uploadFileToSalesforce(filePath, fileName) {
    try {
        log(`📤 Uploading ${fileName} to Salesforce`);

        const fileData = await fs.readFile(filePath, {
            encoding: 'base64'
        });

        const res = await axios.post(
            `${SF_INSTANCE_URL}/services/data/v59.0/sobjects/ContentVersion`,
            {
                Title: fileName,
                PathOnClient: fileName,
                VersionData: fileData
            },
            {
                headers: {
                    Authorization: `Bearer ${SF_ACCESS_TOKEN}`,
                    'Content-Type': 'application/json'
                }
            }
        );

        log(`✅ Uploaded: ${fileName}`);

        return res.data.id;

    } catch (err) {
        console.error('❌ Upload ERROR:', err.response?.data || err.message);
        throw err;
    }
}

const FormData = require('form-data');

async function uploadFileMultipart(filePath, fileName) {
    try {
        log(`📤 Multipart upload started: ${fileName}`);

        const form = new FormData();

        // Part 1: metadata
        form.append('entity_content', JSON.stringify({
            Title: fileName,
            PathOnClient: fileName
        }), {
            contentType: 'application/json'
        });

        // Part 2: file stream
        form.append('VersionData', fs.createReadStream(filePath));

        const res = await axios.post(
            `${SF_INSTANCE_URL}/services/data/v59.0/sobjects/ContentVersion`,
            form,
            {
                headers: {
                    Authorization: `Bearer ${SF_ACCESS_TOKEN}`,
                    ...form.getHeaders()
                },
                maxContentLength: Infinity,
                maxBodyLength: Infinity
            }
        );

        log(`✅ Multipart upload complete: ${fileName}`);

        return res.data.id;

    } catch (err) {
        console.error('❌ Multipart Upload ERROR:', err.response?.data || err.message);
        throw err;
    }
}

function buildDropboxPath(folderName) {
    const BASE_PATH = '/Brabo benefits/Payroll - Shared/ACTIVE PAYROLL CLIENTS'; ///Brabo benefits/Payroll - Shared/Termed CLIENTS
    return `${BASE_PATH}/${folderName}`;
}

async function getAllDropboxFoldersFromSF() {
    try {
        const query = `
            SELECT Id, Name 
            FROM Previous_dropbox_documents__c WHERE Migration_Status__c != 'Completed' 
        `;

        const url = `${SF_INSTANCE_URL}/services/data/v59.0/query?q=${encodeURIComponent(query)}`;

        const res = await axios.get(url, {
            headers: { Authorization: `Bearer ${SF_ACCESS_TOKEN}` }
        });

        return res.data.records; // [{Id, Name}]
    } catch (err) {
        console.error('❌ getAllDropboxFoldersFromSF ERROR:', err.response?.data || err.message);
        throw err;
    }
}

async function updateStatus(recordId, status) {
    await axios.patch(
        `${SF_INSTANCE_URL}/services/data/v59.0/sobjects/Previous_dropbox_documents__c/${recordId}`,
        { Migration_Status__c: status },
        {
            headers: { Authorization: `Bearer ${SF_ACCESS_TOKEN}` }
        }
    );
}

async function processFile(file, recordId, folderName, counters) {
    if (stopRequested) {
        log('🛑 Skipping file due to timeout');
        return;
    }
    try {
        log(`📄 Processing: ${file.name}`);

        const tempPath = await downloadToTemp(file);

        const sfFileName = generateSalesforceFileName(file);

        const cvId = await uploadFileMultipart(tempPath, sfFileName);

        const docId = await getContentDocumentId(cvId);

        await linkFile(docId, recordId);

        await fs.remove(tempPath);

        counters.success++;

        log(`✅ Completed: ${file.name}`);

    } catch (err) {
        counters.failed++;
        log(`❌ Failed: ${file.name} → ${err.message}`);
    } finally {
        counters.processed++;
        if (stopRequested) {
            log('🛑 Stopping further processing...');
            throw new Error('STOP_EXECUTION');
        }
        log(`📊 Progress: ${counters.processed}/${counters.total}`);
    }
}

// ----------- MAIN -------------------------
async function migrate() {

    const config = await getRuntimeConfig();

    DROPBOX_TOKEN = config.DROPBOX_TOKEN;
    SF_ACCESS_TOKEN = config.SF_ACCESS_TOKEN;
    SF_INSTANCE_URL = config.SF_INSTANCE_URL;

    const fetch = require('node-fetch');
    dbx = new Dropbox({ accessToken: DROPBOX_TOKEN, fetch });

    const folders = await getAllDropboxFoldersFromSF();

    log(`📁 Total folders from SF: ${folders.length}`);

    let folderIndex = 0;

    for (const folder of folders) {
        if (stopRequested) {
        log('🛑 Migration stopped before next folder');
        break;
    }
        folderIndex++;

        await updateStatus(folder.Id, 'In Progress');

        const folderSummary = {
            folderName: folder.Name,
            totalFiles: 0,
            success: 0,
            failed: 0
        };

        try {
            const recordId = folder.Id;
            const dropboxPath = buildDropboxPath(folder.Name);

            log(`\n🚀 Folder ${folderIndex}/${folders.length}: ${folder.Name}`);
            log(`📂 Path: ${dropboxPath}`);

            const files = await listFiles(dropboxPath);

            folderSummary.totalFiles = files.length;

            log(`📄 Total files: ${files.length}`);

            const counters = {
                total: files.length,
                processed: 0,
                success: 0,
                failed: 0
            };

            const tasks = files.map(file =>
                limit(() =>
                    retry(() => processFile(file, recordId, folder.Name, counters))
                )
            );

            // await Promise.all(tasks);
            try {
                await Promise.all(tasks);
            } catch (err) {
                if (err.message === 'STOP_EXECUTION') {
                    log('🛑 Execution stopped due to timeout');
                    break;
                }
                throw err;
            }

            folderSummary.success = counters.success;
            folderSummary.failed = counters.failed;

            await updateStatus(folder.Id, 'Completed');

            log(`✅ Folder Done: ${folder.Name}`);
            log(`📊 Success: ${counters.success}, Failed: ${counters.failed}`);

        } catch (err) {
            log(`❌ Folder Failed: ${folder.Name} → ${err.message}`);

            folderSummary.failed = folderSummary.totalFiles;

            await updateStatus(folder.Id, 'Failed');
        }
      if (!stopRequested) {
       
    
        report.push(folderSummary);
        updateExcelReport(folderSummary);
      }
    }

    //await updateExcelReport(folderSummary);

    log('🎉 Migration Complete');
}

migrate().then(() => {
    console.log('✅ Done. Press Enter to exit...');
    process.stdin.resume();
});