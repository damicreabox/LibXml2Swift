import PackageDescription

let package = Package(
    name: "LibXml2Swift",
    dependencies: [
	.Package(url: "https://github.com/damicreabox/CLibxml2.git", majorVersion: 0)
    ]
)
