/**
 * Created by mrahman on 2020-08-24.
 */
({
    getJsonFromUrl: function() {
        var query = location.search.substr(1);
        var result = {}; 

        query.split("&").forEach(function(part) {
            var item = part.split("=");
            var siteName = decodeURIComponent(item[1]);
            if(siteName === "undefined"){
                console.log("siteName is undefined");
//            }
                result[item[0]] = "-1"; //decodeURIComponent(item[1]);
            } else {
//                result[item[0]] = decodeURIComponent(item[1]);
            }
//            result[item[0]] = decodeURIComponent(item[1]);
        });
        console.log('result:: ' + JSON.Stringify(result));
        return result;
    }
})