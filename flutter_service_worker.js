'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {".git/COMMIT_EDITMSG": "3bd76d27651ea4d1a42c72cb26d254ab",
".git/config": "24577c33120be3ab50533de10df96dc7",
".git/description": "a0a7c3fff21f2aea3cfa1d0316dd816c",
".git/FETCH_HEAD": "beac3bd2bd8788228b8f156dfcbbfd07",
".git/HEAD": "cf7dd3ce51958c5f13fece957cc417fb",
".git/hooks/applypatch-msg.sample": "ce562e08d8098926a3862fc6e7905199",
".git/hooks/commit-msg.sample": "579a3c1e12a1e74a98169175fb913012",
".git/hooks/fsmonitor-watchman.sample": "a0b2633a2c8e97501610bd3f73da66fc",
".git/hooks/post-update.sample": "2b7ea5cee3c49ff53d41e00785eb974c",
".git/hooks/pre-applypatch.sample": "054f9ffb8bfe04a599751cc757226dda",
".git/hooks/pre-commit.sample": "5029bfab85b1c39281aa9697379ea444",
".git/hooks/pre-merge-commit.sample": "39cb268e2a85d436b9eb6f47614c3cbc",
".git/hooks/pre-push.sample": "2c642152299a94e05ea26eae11993b13",
".git/hooks/pre-rebase.sample": "56e45f2bcbc8226d2b4200f7c46371bf",
".git/hooks/pre-receive.sample": "2ad18ec82c20af7b5926ed9cea6aeedd",
".git/hooks/prepare-commit-msg.sample": "2b5c047bdb474555e1787db32b2d2fc5",
".git/hooks/push-to-checkout.sample": "c7ab00c7784efeadad3ae9b228d4b4db",
".git/hooks/sendemail-validate.sample": "4d67df3a8d5c98cb8565c07e42be0b04",
".git/hooks/update.sample": "647ae13c682f7827c22f5fc08a03674e",
".git/index": "b6a090dc855e8464d2821fba57019ee8",
".git/info/exclude": "036208b4a1ab4a235d75c181e685e5a3",
".git/logs/HEAD": "33c6e283107c90c3a259d362efc0c9a6",
".git/logs/refs/heads/main": "fce4589422fc4f8a80c8256ab47a799e",
".git/logs/refs/remotes/origin/main": "2954f705c0ede91276e0c007303b9500",
".git/objects/00/8335b52a1af6916bfafe37373a5f9f250c4224": "270182704506011fab97a6d3466fb804",
".git/objects/02/d379985de129bf1118143f9405993014d84a88": "49a3fd720a605cdff3cce75df2a0f8a8",
".git/objects/05/a9058f513cce5faf1704e06e3c150688b0a01f": "e8d02f60cf87abd4c1de4b153dd696dc",
".git/objects/06/5a156ad876ae75d08bca0aabc8c1e01f285abb": "1338ac20d12542d14345378e2fe2be26",
".git/objects/0a/a454c437fdbd077f7af676ddd3aaaba7d1bf54": "e3cbc4bac888b85b1f0691c36b20b93e",
".git/objects/13/e730a7bd799ec205dbb39f7b74b0c43259a18f": "05f2269c4d1d3bdea53fe525c22bf3a0",
".git/objects/15/52478be88815b8a47b109ac43449ded9dada20": "09727e1492412dd203883197d0b3d89e",
".git/objects/1a/20e2311ed810801947081370a9fd4b1a726bfc": "6605d06783a062b818189b0784d33ec1",
".git/objects/1a/f27568218994732f516acd7b27a11702396cf9": "7a06598662d8bc211ac4816434df4f42",
".git/objects/1f/45b5bcaac804825befd9117111e700e8fcb782": "7a9d811fd6ce7c7455466153561fb479",
".git/objects/1f/d1d3782758450a37630d9e5db47a23b7567c1a": "739884690bd005b50d2bdb58846886e8",
".git/objects/20/6aa4ada75714e2df6709c7b51bc1276c191388": "66f3be8d7c9e195e0ac70b5829e68407",
".git/objects/21/c9004441fd7e323e77a6722c8c07c72cc52836": "3f713d247a1cb68163513f629d749091",
".git/objects/23/637bc3573701e2ad80a6f8be31b82926b4715f": "5f84f5c437bb2791fdc8411523eae8ff",
".git/objects/27/a297abdda86a3cbc2d04f0036af1e62ae008c7": "51d74211c02d96c368704b99da4022d5",
".git/objects/28/318715dbb232bb89a6e64a4afdd12137d0eda1": "2f7d6262af8be2174cb5a3a82005f32f",
".git/objects/2a/a66eae93af1a1e69e15eb99bea34e99f4ed4d9": "c7441dbba959b9ecf86e3b594af440a3",
".git/objects/2d/0471ef9f12c9641643e7de6ebf25c440812b41": "d92fd35a211d5e9c566342a07818e99e",
".git/objects/2e/60284ff6723ecbd5d6c6a4ebff98da53570a20": "e294d874fe465cdb77fa3e1fc52d7c72",
".git/objects/2e/734c9d70912598923e534844bd5f2b334805d1": "70ff7f4860a37338cdc25a4765ee89a7",
".git/objects/2e/b9acd2d948bf3b81737c46bacecefe9818cb7e": "b99cb3aa8f99fcf63d65e9a0b515f2d9",
".git/objects/35/c092e1e4259e3f7669fc3406da9af7338b80af": "bc119a0dccb3c3ae19d481f2711aba5b",
".git/objects/35/d77f23032e96b58d161e4f79c4bc1af89dd796": "ce452a7500005f8fd33251a374f19602",
".git/objects/38/f72c3b661274731c0dca4263c6147292c3313e": "06ec909689545717240ec77454003efe",
".git/objects/3b/b0860a0981211a1ab11fced3e6dad7e9bc1834": "3f00fdcdb1bb283f5ce8fd548f00af7b",
".git/objects/42/6e2afb215f85ba331129d662dc1b62623f48d0": "71c668e984c5d094b29d752d3dc0e469",
".git/objects/42/b2a13ef771198105a2fc9263c9244bc5ad671b": "e81e115054d2fa6b73f0812665201250",
".git/objects/42/e83adc531ab834e814faa4134740371098bd9f": "797218e5b863172560463ebe75db4921",
".git/objects/44/3723bbf3bafa038ee112d364d7d70d508f0a40": "17bc5ce4efad3a043360d3fb0d0cdea8",
".git/objects/47/a113da3cac77029e884aaec7f9b63e12c4f555": "e810464dd7768ee047dcdc0191edfe12",
".git/objects/4c/50f699ab81944e7b056d37e3589eccc0983007": "57645afcb84a3783f2e4ed404cf40ec0",
".git/objects/4c/d3fb69c5b77f5553a7565fcb324ef2170e14bc": "3fb79bb1323355b006d8afd3aca058e8",
".git/objects/56/6e9687e624c3159d68dd5cc827ecb90dabe2f5": "47058a339a0583da2e48b9e7a0228f94",
".git/objects/59/0587415c1ee338196ac4f9258e22705662e4af": "3126dfdfc2dd9ac62c03a47dcd516324",
".git/objects/5b/809b18640b33364acccb797c5363b939d7c1d2": "238d2c08d04042ae1648517589d74dd3",
".git/objects/5b/8e34c5dc304adbeeb0ee481bae41f74089469c": "85b88c08f8d3c62c82f479421660dcfd",
".git/objects/5b/9f7e63f54a7b7ca456e9e82de194997bff238a": "aa3b644cbb2b8d5c7eec82e216c32b41",
".git/objects/5d/07c43a8ed5cf5bd2a545ce0841a561e6b30509": "525114f7bd561981a52f99af399d3ba7",
".git/objects/5e/1a195e7d8affb9e3780c6fd9a3a1741eee4162": "8c29d9b8b61054cfa7aa1db483c17d0f",
".git/objects/5e/4b93afd3cd2e8b210431bae51f9fe181827e8d": "43e60be547aa8d3450e5011bfac852c7",
".git/objects/5e/bf37944a56f2b5e479e3858392c6e9030da2da": "d874f5ce1eb6512c7b77ebd17b676f00",
".git/objects/63/57525195ce8c4da37db9698f5aba269cb8a311": "7632ed87abe825802f9d175d46e57bf4",
".git/objects/63/6931bcaa0ab4c3ff63c22d54be8c048340177b": "8cc9c6021cbd64a862e0e47758619fb7",
".git/objects/68/04a4db732b794029ac25398e7ff9bce2983420": "666184c15b45cdb2694a4b18596bdb43",
".git/objects/69/739fffa024cda2b04f90f48fe71d51580ca372": "3a15710a5adc4ae4e0888689d0cd05af",
".git/objects/6d/5f0fdc7ccbdf7d01fc607eb818f81a0165627e": "2b2403c52cb620129b4bbc62f12abd57",
".git/objects/70/21edfe24f3be1886be6edcbc29f887262998ac": "4fd7dbc3e6971be21fa7f52d8ee3bdff",
".git/objects/73/7f149c855c9ccd61a5e24ce64783eaf921c709": "1d813736c393435d016c1bfc46a6a3a6",
".git/objects/75/a6aa37f1f0ca00f156eb1ea23bea5325f58938": "f7edc4da78fa7612cd6e6c6cca610907",
".git/objects/78/47f2f7da3b51a45672126659b95a0e046d2471": "5c22e521de0ec378b127a647e3864c91",
".git/objects/7c/d3705aaad3d45e7baae63c503a1d51793bc8da": "c612c2a52dc6eaf7fbfe6c75c5c940a7",
".git/objects/7f/acd12c34017a7bbbbc3e5cc429534d223559aa": "127d8712b9752c7eeb52be1e78e7a1b5",
".git/objects/81/ba5936928e6734f76c83017ac1ff8fcd825880": "3f99bbf5296e793a2024d8be0b0524f0",
".git/objects/81/e46f24a8217c5c3bd94eea5f4260e4cc270a05": "f6271202aa612fb1731319e60236e854",
".git/objects/84/4a8ae4d2154235af765fcd50f6c33587e50527": "1ac931c768b44c103c0d4f808bf5cf3b",
".git/objects/85/6a39233232244ba2497a38bdd13b2f0db12c82": "eef4643a9711cce94f555ae60fecd388",
".git/objects/86/a90168ae8b5f9ec67e0c5285e171f408039f36": "d4c03b159abffef416278ecd315b22ba",
".git/objects/87/976fec52b9be0fd4e75a26d70682a9f5a503f6": "542b033613e2747a8060c687b8995fa7",
".git/objects/88/05443a0a53fd7b4f823e364f1cb3f994f07086": "12dd4d46e64052cfcba050ee0ffe4c16",
".git/objects/89/2bf98c38b19a32fd224b9904b4eedf7cd5d01a": "3a81385cc8d8568433e22c93b9b9ada4",
".git/objects/89/385e07fabe119cc7a7883afadba8cf7758ef0f": "c1f1f39d2db6be85a6be9b239394f689",
".git/objects/89/d58e5f1a283d8ca60defe84112b1dd0edc264d": "c09e8bb91b7be67dfdeb2fde5a6d56a7",
".git/objects/8a/85cae1e2ad87dceb06e928fed87dfbd4ff49f8": "17e1c49ad6c8944481b8ed3921cdaea5",
".git/objects/8b/137891791fe96927ad78e64b0aad7bded08bdc": "9abb042e8c58ed4d703beb8e66b37150",
".git/objects/8c/2bd99582d6e3baf102b31891b42b02f848f3b9": "0cbb92c350a8a8f81a4d1fb5e8c48c45",
".git/objects/8c/59773bee8314a8ffb4431593d0fb49f52e34c6": "2eb993d30677573ffd0e58484cc6a514",
".git/objects/8f/0b774b737712ed6f54f14e4bf87f6f86750ce0": "6647545e8fc27b98756b1737716cc8ca",
".git/objects/8f/372fa753f392e2836eca1f07966a8b1db6c964": "65f6b28ae6dc6962ec89487121035021",
".git/objects/92/b5183fc447600243e6d24418f6bff9c66e9ab7": "e94c1cc567c28b485d026bbf63976f0f",
".git/objects/94/a7b2d3d405f62e1e031e586bbe12f6254f0c1f": "6db2a81ca78573317e211e3511e14c5a",
".git/objects/95/4c0e32f4a0887f1b83f66d69beb79131680543": "a2e31c9b31a15050f973221b5a10f153",
".git/objects/95/6cec8501d61134ca402f8b5069f7a416b64fb4": "bfbe105d85b37cff03e70074651d6452",
".git/objects/97/8a4d89de1d1e20408919ec3f54f9bba275d66f": "dbaa9c6711faa6123b43ef2573bc1457",
".git/objects/98/026c46930d86492815359fb4c6aff0aa9d0e81": "9772f697a00da9b5c9d6fa7109bd6ed9",
".git/objects/99/4f448c5f88f4b7d19e717aa18a2ca325f45323": "ab12591f019dbae7fa51235b99e7c1fc",
".git/objects/9b/dbfb0313ec3b28481174257fdf9043ca29916c": "424e367bd1e01770cec6c476c2c52367",
".git/objects/a1/930c12ed610a147c4b3bb14499378e0dab06d9": "cf04438d9559499ca4ab379fa1595df3",
".git/objects/a5/4b522c71258fbc0327bd8b33b7737c95e440f3": "157341ceb21c467159b46e5ccf7ebec7",
".git/objects/a7/22b8d3e15890830a2b20ec322c6be7f151f681": "9b802c980f8ef24a474fdd42c28c0720",
".git/objects/a8/b5342d3d372023d9265c1e30e0fb523cc5a67d": "3dd6c615c90959945d0f62352bad3fba",
".git/objects/a8/b773871befc563f1e3aa030fe830acda3c2b59": "89880d1db3d238c3b6af092682fc548e",
".git/objects/af/31ef4d98c006d9ada76f407195ad20570cc8e1": "a9d4d1360c77d67b4bb052383a3bdfd9",
".git/objects/b1/5ad935a6a00c2433c7fadad53602c1d0324365": "8f96f41fe1f2721c9e97d75caa004410",
".git/objects/b1/afd5429fbe3cc7a88b89f454006eb7b018849a": "e4c2e016668208ba57348269fcb46d7b",
".git/objects/b2/4ff196ada8e23b280e3ad119e8abc6617ad471": "0b2057e638b1be37afad27500e4f36a5",
".git/objects/b8/3e54a66c6a4f68eea4782df9d1c230827ab590": "07680b29484f7a77a79b721b161a46d6",
".git/objects/b9/83f40fc73c266219f9578be74f3257678ed4fc": "de6d4b79ee18508165ad2fc8c6ecaa4e",
".git/objects/ba/433f2ece03cefb773f1b182bf60b007e231f4f": "e4897dc62d87dd1c1e6633776b8ec5e6",
".git/objects/ba/5317db6066f0f7cfe94eec93dc654820ce848c": "9b7629bf1180798cf66df4142eb19a4e",
".git/objects/bf/310849c93749131f16834b839a0e0a8d76cbba": "97a955a456905549c65c75ce1eb96546",
".git/objects/c0/266f99797c99add19f2680f63cbe848a75755f": "fce56a58101047d0de5e727567f524cc",
".git/objects/c3/e81f822689e3b8c05262eec63e4769e0dea74c": "8c6432dca0ea3fdc0d215dcc05d00a66",
".git/objects/c6/06caa16378473a4bb9e8807b6f43e69acf30ad": "ed187e1b169337b5fbbce611844136c6",
".git/objects/c7/03dd3b2eca0a40cbdc4af7f60b7a54bb8eb247": "89900ad3b30bc75e84ac7530e3e98820",
".git/objects/c7/7663172ca915a99a594ca17d06f527db05657d": "6335b074b18eb4ebe51f3a2c609a6ecc",
".git/objects/c8/d85c757a9d8409e1cabf8ef7a0ca534e160efe": "aa951183f600f3d927b7b7666dc6b490",
".git/objects/ca/fcccf1eb33284d01829bf91462fd18504d5cb5": "f27cdf1b01082eb98f9ada7e8ee96bee",
".git/objects/cc/c232f01fb33f47bcd934f5ec991e2790afdf38": "065cad67d6a229aa8f96df2fc23788fa",
".git/objects/ce/e3c5bb4ad9ca1b7e02e3391cc1cbba998308b7": "8e23cc0d8eea61c17a30b19ec3ccb417",
".git/objects/d4/3532a2348cc9c26053ddb5802f0e5d4b8abc05": "3dad9b209346b1723bb2cc68e7e42a44",
".git/objects/d8/0c66f82e29175518a2f87b866e8c7569d06800": "2bca5c7b1cf3623a3a6229f2e8621a82",
".git/objects/d9/55d6677ead74d0763541775743f1423657e7b2": "6f1d5d2aaf1e85720406dc22509a82d8",
".git/objects/db/370520e1f41202e366142a983c645ac45bab8e": "290998448b6aaf1c3cdb7f995eea4030",
".git/objects/e6/12e9c4fc8f807978c398a8b473f7b0715a9b5f": "724e543bbce1e597837d1073dd90f09b",
".git/objects/e7/f579f885040212a0c37f6510245255fd8f6bb6": "5e070e6e4ae8ee2ffe90c7f7f3c9975c",
".git/objects/e9/2aa835e59016f2dda51a3f458c424be305c669": "13390d9d10ee8a7badf4ad49ac298ca2",
".git/objects/ec/2258c0b26af065abeb337c1ab27deeb113faf3": "8fa1c9e9c719794cf24e084ed052eb8d",
".git/objects/ec/361605e9e785c47c62dd46a67f9c352731226b": "d1eafaea77b21719d7c450bcf18236d6",
".git/objects/ee/0d97d6d1af478bd4ca81a118ab84f3d46573e5": "be5134ff0704988332f534bd2b6fc138",
".git/objects/f2/04823a42f2d890f945f70d88b8e2d921c6ae26": "6b47f314ffc35cf6a1ced3208ecc857d",
".git/objects/f4/ebae7c665bb7a67425b109dbc6ddaaefb08dfd": "6ab0583ad7c1e28009e53007a23aa22e",
".git/objects/f6/6f3c0667fb05053568bf41d3bb2c8c95e65f44": "0f6427dfb6a551822e7586a08629203d",
".git/objects/f8/90ff808604294b18abe81de71805d9275dce0c": "76509f6fed0beb2893dcc7f404b2e4d1",
".git/objects/f8/b586c7e12573970636c188118b7361e8f11852": "ad9d2ef11864ad6e77432ee2e40b922d",
".git/ORIG_HEAD": "01e303d7253dd3f488cbcfddb5635e0c",
".git/REBASE_HEAD": "01e303d7253dd3f488cbcfddb5635e0c",
".git/refs/heads/main": "3dfc4dae6646b667a619b15513dcb79f",
".git/refs/remotes/origin/main": "3dfc4dae6646b667a619b15513dcb79f",
".well-known/assetlinks.json": "dfeadd2f1c2801df0edb96d2b83628da",
"assets/AssetManifest.bin": "eee0bd97cd68f52ae406b8c906cf3440",
"assets/AssetManifest.bin.json": "0c5dfb0bfa416f2f3120887d324cc660",
"assets/AssetManifest.json": "1e74f231bc5b3cc89ceb709bf691af2e",
"assets/assets/animations/Cyber%2520Security.json": "64995ce717840743c58ee3f25a79c957",
"assets/assets/animations/Delivery%2520Dron.json": "92f877ef728ac051d3cef4a238cd1c98",
"assets/assets/animations/Email%2520verification.json": "1ce7a79c7e7a0950cef9f133d1e1d342",
"assets/assets/animations/error_alert.json": "501131b336c9aa725950f7733b168860",
"assets/assets/animations/Forget%2520pasword.json": "d7265bd873b29912618fbd97211b271e",
"assets/assets/animations/heart_break.json": "e06edbb7f069d53a84f4eeceb02727ec",
"assets/assets/animations/heart_fill.json": "5d08c9ae5e32ba0e1e6f5785381a0f89",
"assets/assets/animations/Loading.json": "b90bcb6ceb76c0b8d884749a00dc68e4",
"assets/assets/animations/shopping_cart.json": "5f0ea85c2fd6d2a9e5cc1b86a610d004",
"assets/assets/animations/success_check.json": "a6ef5de2fa3d23a7d8f43bf1a3baa1c1",
"assets/assets/animations/Verified%2520Tick.json": "a1a340e39a5b4d7fc94ccb5195156ed6",
"assets/assets/animations/Welcome.json": "6a48c0485ddd84c55ca8a23fe00187cb",
"assets/assets/icon/icon.png": "4ab8b8d500fbd97fa270de17366bb458",
"assets/assets/images/icon.png": "4ab8b8d500fbd97fa270de17366bb458",
"assets/assets/images/old_chair.glb": "757411011b759ca58227266c17160721",
"assets/FontManifest.json": "5a32d4310a6f5d9a6b651e75ba0d7372",
"assets/fonts/MaterialIcons-Regular.otf": "c87afa2cdcd6a747cab5df709d376343",
"assets/NOTICES": "5994df937b3f3c00e07fe56bd37fd1ea",
"assets/packages/cupertino_icons/assets/CupertinoIcons.ttf": "e986ebe42ef785b27164c36a9abc7818",
"assets/packages/fluttertoast/assets/toastify.css": "a85675050054f179444bc5ad70ffc635",
"assets/packages/fluttertoast/assets/toastify.js": "56e2c9cedd97f10e7e5f1cebd85d53e3",
"assets/packages/font_awesome_flutter/lib/fonts/fa-brands-400.ttf": "4769f3245a24c1fa9965f113ea85ec2a",
"assets/packages/font_awesome_flutter/lib/fonts/fa-regular-400.ttf": "3ca5dc7621921b901d513cc1ce23788c",
"assets/packages/font_awesome_flutter/lib/fonts/fa-solid-900.ttf": "a2eb084b706ab40c90610942d98886ec",
"assets/packages/model_viewer_plus/assets/model-viewer.min.js": "a9dc98f8bf360be897a0898a7395f905",
"assets/packages/model_viewer_plus/assets/template.html": "8de94ff19fee64be3edffddb412ab63c",
"assets/packages/sign_in_button/assets/logos/2.0x/facebook_new.png": "dd8e500c6d946b0f7c24eb8b94b1ea8c",
"assets/packages/sign_in_button/assets/logos/2.0x/google_dark.png": "68d675bc88e8b2a9079fdfb632a974aa",
"assets/packages/sign_in_button/assets/logos/2.0x/google_light.png": "1f00e2bbc0c16b9e956bafeddebe7bf2",
"assets/packages/sign_in_button/assets/logos/3.0x/facebook_new.png": "689ce8e0056bb542425547325ce690ba",
"assets/packages/sign_in_button/assets/logos/3.0x/google_dark.png": "c75b35db06cb33eb7c52af696026d299",
"assets/packages/sign_in_button/assets/logos/3.0x/google_light.png": "3aeb09c8261211cfc16ac080a555c43c",
"assets/packages/sign_in_button/assets/logos/facebook_new.png": "93cb650d10a738a579b093556d4341be",
"assets/packages/sign_in_button/assets/logos/google_dark.png": "d18b748c2edbc5c4e3bc221a1ec64438",
"assets/packages/sign_in_button/assets/logos/google_light.png": "f71e2d0b0a2bc7d1d8ab757194a02cac",
"assets/shaders/ink_sparkle.frag": "ecc85a2e95f5e9f53123dcaf8cb9b6ce",
"canvaskit/canvaskit.js": "26eef3024dbc64886b7f48e1b6fb05cf",
"canvaskit/canvaskit.js.symbols": "efc2cd87d1ff6c586b7d4c7083063a40",
"canvaskit/canvaskit.wasm": "e7602c687313cfac5f495c5eac2fb324",
"canvaskit/chromium/canvaskit.js": "b7ba6d908089f706772b2007c37e6da4",
"canvaskit/chromium/canvaskit.js.symbols": "e115ddcfad5f5b98a90e389433606502",
"canvaskit/chromium/canvaskit.wasm": "ea5ab288728f7200f398f60089048b48",
"canvaskit/skwasm.js": "ac0f73826b925320a1e9b0d3fd7da61c",
"canvaskit/skwasm.js.symbols": "96263e00e3c9bd9cd878ead867c04f3c",
"canvaskit/skwasm.wasm": "828c26a0b1cc8eb1adacbdd0c5e8bcfa",
"canvaskit/skwasm.worker.js": "89990e8c92bcb123999aa81f7e203b1c",
"favicon.png": "6bade141f994d090b943d6138b5c1dcd",
"flutter.js": "4b2350e14c6650ba82871f60906437ea",
"flutter_bootstrap.js": "7717e70dafe1dfb8a21a16ec9af62f96",
"icons/Icon-192.png": "b6f5f5e25c0898922c76c8c72f934f8a",
"icons/Icon-512.png": "0ce1dc00429e3b8a792380261672f746",
"icons/Icon-maskable-192.png": "b6f5f5e25c0898922c76c8c72f934f8a",
"icons/Icon-maskable-512.png": "0ce1dc00429e3b8a792380261672f746",
"index.html": "d52fd380b93ca7eb2db7bdbc320e6519",
"/": "d52fd380b93ca7eb2db7bdbc320e6519",
"main.dart.js": "3cb5104599f846ad4c0a29bf0173f720",
"manifest.json": "dee1c6249463419bc504b10fad7f04d5",
"README.md": "963bafd7fa879f74b8a4a98c91e1272a",
"version.json": "2bc34e4713845ac7b64bb68aca7bd52d"};
// The application shell files that are downloaded before a service worker can
// start.
const CORE = ["main.dart.js",
"index.html",
"flutter_bootstrap.js",
"assets/AssetManifest.bin.json",
"assets/FontManifest.json"];

// During install, the TEMP cache is populated with the application shell files.
self.addEventListener("install", (event) => {
  self.skipWaiting();
  return event.waitUntil(
    caches.open(TEMP).then((cache) => {
      return cache.addAll(
        CORE.map((value) => new Request(value, {'cache': 'reload'})));
    })
  );
});
// During activate, the cache is populated with the temp files downloaded in
// install. If this service worker is upgrading from one with a saved
// MANIFEST, then use this to retain unchanged resource files.
self.addEventListener("activate", function(event) {
  return event.waitUntil(async function() {
    try {
      var contentCache = await caches.open(CACHE_NAME);
      var tempCache = await caches.open(TEMP);
      var manifestCache = await caches.open(MANIFEST);
      var manifest = await manifestCache.match('manifest');
      // When there is no prior manifest, clear the entire cache.
      if (!manifest) {
        await caches.delete(CACHE_NAME);
        contentCache = await caches.open(CACHE_NAME);
        for (var request of await tempCache.keys()) {
          var response = await tempCache.match(request);
          await contentCache.put(request, response);
        }
        await caches.delete(TEMP);
        // Save the manifest to make future upgrades efficient.
        await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
        // Claim client to enable caching on first launch
        self.clients.claim();
        return;
      }
      var oldManifest = await manifest.json();
      var origin = self.location.origin;
      for (var request of await contentCache.keys()) {
        var key = request.url.substring(origin.length + 1);
        if (key == "") {
          key = "/";
        }
        // If a resource from the old manifest is not in the new cache, or if
        // the MD5 sum has changed, delete it. Otherwise the resource is left
        // in the cache and can be reused by the new service worker.
        if (!RESOURCES[key] || RESOURCES[key] != oldManifest[key]) {
          await contentCache.delete(request);
        }
      }
      // Populate the cache with the app shell TEMP files, potentially overwriting
      // cache files preserved above.
      for (var request of await tempCache.keys()) {
        var response = await tempCache.match(request);
        await contentCache.put(request, response);
      }
      await caches.delete(TEMP);
      // Save the manifest to make future upgrades efficient.
      await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
      // Claim client to enable caching on first launch
      self.clients.claim();
      return;
    } catch (err) {
      // On an unhandled exception the state of the cache cannot be guaranteed.
      console.error('Failed to upgrade service worker: ' + err);
      await caches.delete(CACHE_NAME);
      await caches.delete(TEMP);
      await caches.delete(MANIFEST);
    }
  }());
});
// The fetch handler redirects requests for RESOURCE files to the service
// worker cache.
self.addEventListener("fetch", (event) => {
  if (event.request.method !== 'GET') {
    return;
  }
  var origin = self.location.origin;
  var key = event.request.url.substring(origin.length + 1);
  // Redirect URLs to the index.html
  if (key.indexOf('?v=') != -1) {
    key = key.split('?v=')[0];
  }
  if (event.request.url == origin || event.request.url.startsWith(origin + '/#') || key == '') {
    key = '/';
  }
  // If the URL is not the RESOURCE list then return to signal that the
  // browser should take over.
  if (!RESOURCES[key]) {
    return;
  }
  // If the URL is the index.html, perform an online-first request.
  if (key == '/') {
    return onlineFirst(event);
  }
  event.respondWith(caches.open(CACHE_NAME)
    .then((cache) =>  {
      return cache.match(event.request).then((response) => {
        // Either respond with the cached resource, or perform a fetch and
        // lazily populate the cache only if the resource was successfully fetched.
        return response || fetch(event.request).then((response) => {
          if (response && Boolean(response.ok)) {
            cache.put(event.request, response.clone());
          }
          return response;
        });
      })
    })
  );
});
self.addEventListener('message', (event) => {
  // SkipWaiting can be used to immediately activate a waiting service worker.
  // This will also require a page refresh triggered by the main worker.
  if (event.data === 'skipWaiting') {
    self.skipWaiting();
    return;
  }
  if (event.data === 'downloadOffline') {
    downloadOffline();
    return;
  }
});
// Download offline will check the RESOURCES for all files not in the cache
// and populate them.
async function downloadOffline() {
  var resources = [];
  var contentCache = await caches.open(CACHE_NAME);
  var currentContent = {};
  for (var request of await contentCache.keys()) {
    var key = request.url.substring(origin.length + 1);
    if (key == "") {
      key = "/";
    }
    currentContent[key] = true;
  }
  for (var resourceKey of Object.keys(RESOURCES)) {
    if (!currentContent[resourceKey]) {
      resources.push(resourceKey);
    }
  }
  return contentCache.addAll(resources);
}
// Attempt to download the resource online before falling back to
// the offline cache.
function onlineFirst(event) {
  return event.respondWith(
    fetch(event.request).then((response) => {
      return caches.open(CACHE_NAME).then((cache) => {
        cache.put(event.request, response.clone());
        return response;
      });
    }).catch((error) => {
      return caches.open(CACHE_NAME).then((cache) => {
        return cache.match(event.request).then((response) => {
          if (response != null) {
            return response;
          }
          throw error;
        });
      });
    })
  );
}
