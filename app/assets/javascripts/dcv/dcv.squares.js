if (typeof(Dcv) == 'undefined') Dcv = function(){};
Dcv.Squares = Dcv.Squares || function(){}; 
Dcv.Squares.random = function(_img_array, limit) {
	var imgs = {};
    while (Object.keys(imgs).length < limit){ // magic 12x5 grid
    	var ix = Math.floor(Math.random() * (_img_array.length + 1));
    	if (ix > limit -1) continue;
    	imgs[_img_array[ix]] = _img_array[ix] + ".jpg"
    }
    var img_names = [];
    for (var i in imgs) {
    	img_names.push(imgs[i]);
    }
    return img_names;
}
Dcv.Squares.CPG = function(){};
Dcv.Squares.CPG.random = function(limit) {
	return Dcv.Squares.random(Dcv.Squares.CPG.Images,limit);
}
Dcv.Squares.RICOP = function(){};
Dcv.Squares.RICOP.random = function(limit) {
	return Dcv.Squares.random(Dcv.Squares.RICOP.Images,limit);
}
Dcv.Squares.CPG.Images = [
"ldpd_114015",
"ldpd_114012",
"ldpd_114011",
"ldpd_114022",
"ldpd_114058",
"ldpd_114177",
"ldpd_114086",
"ldpd_114089",
"ldpd_114098",
"ldpd_114181",
"ldpd_114182",
"ldpd_114176",
"ldpd_114137",
"ldpd_114153",
"ldpd_114202",
"ldpd_114161",
"ldpd_114175",
"ldpd_114174",
"ldpd_114208",
"ldpd_114113",
"ldpd_114006",
"ldpd_114001",
"ldpd_114726",
"ldpd_114624",
"ldpd_114928",
"ldpd_114700",
"ldpd_114694",
"ldpd_114903",
"ldpd_114901",
"ldpd_115027",
"ldpd_114312",
"ldpd_114795",
"ldpd_114781",
"ldpd_114782",
"ldpd_114275",
"ldpd_114779",
"ldpd_114757",
"ldpd_114909",
"ldpd_114747",
"ldpd_114879",
"ldpd_114248",
"ldpd_114731",
"ldpd_114724",
"ldpd_114729",
"ldpd_114715",
"ldpd_114716",
"ldpd_114717",
"ldpd_114604",
"ldpd_114705",
"ldpd_114704",
"ldpd_114512",
"ldpd_115013",
"ldpd_114225",
"ldpd_114520",
"ldpd_114245",
"ldpd_114505",
"ldpd_114264",
"ldpd_114626",
"ldpd_114501",
"ldpd_114610",
"ldpd_115003",
"ldpd_114998",
"ldpd_114668",
"ldpd_114650",
"ldpd_114685",
"ldpd_114559",
"ldpd_114970",
"ldpd_114359",
"ldpd_114543",
"ldpd_114682",
"ldpd_114984",
"ldpd_114575",
"ldpd_114346",
"ldpd_114966",
"ldpd_115002",
"ldpd_114870",
"ldpd_114896",
"ldpd_114892",
"ldpd_114338",
"ldpd_114869",
"ldpd_114854",
"ldpd_114871",
"ldpd_114306",
"ldpd_114827",
"ldpd_114309",
"ldpd_114555",
"ldpd_114845",
"ldpd_114841",
"ldpd_114416",
"ldpd_114838",
"ldpd_114364",
"ldpd_114526",
"ldpd_114546",
"ldpd_114518",
"ldpd_114533",
"ldpd_114957",
"ldpd_114494",
"ldpd_115006",
"ldpd_114545",
"ldpd_114539",
"ldpd_114532",
"ldpd_114516",
"ldpd_114330",
"ldpd_114415",
"ldpd_114572",
"ldpd_114576",
"ldpd_114981",
"ldpd_114458",
"ldpd_114510",
"ldpd_114530",
"ldpd_114262",
"ldpd_114310",
"ldpd_114586",
"ldpd_114585",
"ldpd_115022",
"ldpd_114955",
"ldpd_114659",
"ldpd_114388",
"ldpd_114396",
"ldpd_115018",
"ldpd_114919",
"ldpd_114649",
"ldpd_114470",
"ldpd_114308",
"ldpd_114698",
"ldpd_114314",
"ldpd_114670",
"ldpd_114925",
"ldpd_114926",
"ldpd_114638",
"ldpd_114917",
"ldpd_115302",
"ldpd_115093",
"ldpd_115201",
"ldpd_115155",
"ldpd_115303",
"ldpd_115354",
"ldpd_115357",
"ldpd_115134",
"ldpd_115203",
"ldpd_115204",
"ldpd_115205",
"ldpd_115206",
"ldpd_115202",
"ldpd_115152",
"ldpd_115217",
"ldpd_115111",
"ldpd_115144",
"ldpd_115156",
"ldpd_115291",
"ldpd_115108",
"ldpd_115168",
"ldpd_115135",
"ldpd_115274",
"ldpd_115235",
"ldpd_115183",
"ldpd_115184",
"ldpd_115251",
"ldpd_115178",
"ldpd_115198",
"ldpd_115172",
"ldpd_115171",
"ldpd_115313",
"ldpd_115318",
"ldpd_115159",
"ldpd_115051",
"ldpd_115148",
"ldpd_115057",
"ldpd_115138",
"ldpd_115123",
"ldpd_115122",
"ldpd_115129",
"ldpd_115128",
"ldpd_115126",
"ldpd_115295",
"ldpd_115329",
"ldpd_115271",
"ldpd_115090",
"ldpd_115121",
"ldpd_115116",
"ldpd_115106",
"ldpd_115290",
"ldpd_115356",
"ldpd_115036",
"ldpd_115260",
"ldpd_115189",
"ldpd_115231",
"ldpd_115364",
"ldpd_115298",
"ldpd_115268",
"ldpd_115286",
"ldpd_115300",
"ldpd_115308",
"ldpd_115317",
"ldpd_115349",
"ldpd_115338",
"ldpd_115331",
"ldpd_115284",
"ldpd_115285",
"ldpd_115280",
"ldpd_115275",
"ldpd_115273",
"ldpd_115293",
"ldpd_115068",
"ldpd_115077",
"ldpd_115296",
"ldpd_115289",
"ldpd_115355",
"ldpd_115225",
"ldpd_115224",
"ldpd_115222",
"ldpd_115264",
"ldpd_115257",
"ldpd_115258",
"ldpd_115246",
"ldpd_115049",
"ldpd_115088",
"ldpd_115087",
"ldpd_115359",
"ldpd_115363",
"ldpd_115348",
"ldpd_115342",
"ldpd_115350",
"ldpd_115361",
"ldpd_115367",
"ldpd_115370",
"ldpd_115054",
"ldpd_115081",
"ldpd_115067",
"ldpd_115089"
]

Dcv.Squares.RICOP.Images = [
"ldpd_103",
"ldpd_108",
"ldpd_113",
"ldpd_118",
"ldpd_123",
"ldpd_128",
"ldpd_13",
"ldpd_138",
"ldpd_133",
"ldpd_143",
"ldpd_148",
"ldpd_153",
"ldpd_158",
"ldpd_163",
"ldpd_168",
"ldpd_173",
"ldpd_18",
"ldpd_178",
"ldpd_188",
"ldpd_183",
"ldpd_193",
"ldpd_198",
"ldpd_203",
"ldpd_213",
"ldpd_208",
"ldpd_218",
"ldpd_223",
"ldpd_23",
"ldpd_228",
"ldpd_233",
"ldpd_238",
"ldpd_243",
"ldpd_248",
"ldpd_258",
"ldpd_253",
"ldpd_263",
"ldpd_268",
"ldpd_273",
"ldpd_278",
"ldpd_28",
"ldpd_288",
"ldpd_283",
"ldpd_293",
"ldpd_298",
"ldpd_3",
"ldpd_303",
"ldpd_308",
"ldpd_313",
"ldpd_318",
"ldpd_323",
"ldpd_328",
"ldpd_333",
"ldpd_33",
"ldpd_338",
"ldpd_343",
"ldpd_348",
"ldpd_353",
"ldpd_358",
"ldpd_363",
"ldpd_368",
"ldpd_373",
"ldpd_378",
"ldpd_38",
"ldpd_383",
"ldpd_393",
"ldpd_388",
"ldpd_398",
"ldpd_403",
"ldpd_408",
"ldpd_413",
"ldpd_418",
"ldpd_423",
"ldpd_43",
"ldpd_433",
"ldpd_428",
"ldpd_438",
"ldpd_443",
"ldpd_448",
"ldpd_453",
"ldpd_458",
"ldpd_468",
"ldpd_463",
"ldpd_473",
"ldpd_478",
"ldpd_483",
"ldpd_48",
"ldpd_488",
"ldpd_493",
"ldpd_503",
"ldpd_498",
"ldpd_508",
"ldpd_513",
"ldpd_518",
"ldpd_523",
"ldpd_53",
"ldpd_528",
"ldpd_533",
"ldpd_543",
"ldpd_538",
"ldpd_548",
"ldpd_553",
"ldpd_563",
"ldpd_568",
"ldpd_578",
"ldpd_573",
"ldpd_58",
"ldpd_63",
"ldpd_68",
"ldpd_73",
"ldpd_78",
"ldpd_8",
"ldpd_83",
"ldpd_88",
"ldpd_93",
"ldpd_98"
]