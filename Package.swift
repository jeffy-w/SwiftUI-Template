// swift-tools-version: 6.2

import Foundation
import PackageDescription

let appName = "App"

// MARK: - Third party dependencies

let customDump = SourceControlDependency(
    package: .package(
        url: "https://github.com/pointfreeco/swift-custom-dump",
        exact: "1.3.3"
    ),
    productName: "CustomDump"
)

// MARK: - Local package dependencies

let fvendors = Package.Dependency.package(path: "../FVendors")

// MARK: - Modules. Ordered by dependency hierarchy.

let models = SingleTargetLibrary(
    name: "Models",
    dependencies: [
        .product(name: "FVendors", package: "FVendors")
    ]
)
let dependencyClients = SingleTargetLibrary(
    name: "DependencyClients",
    dependencies: [
        models.targetDependency,
        .product(name: "FVendors", package: "FVendors"),
    ]
)
let features = SingleTargetLibrary(
    name: "Features",
    dependencies: [
        models.targetDependency,
        dependencyClients.targetDependency,
        .product(name: "FVendors", package: "FVendors"),
    ]
)
let views = SingleTargetLibrary(
    name: "Views",
    dependencies: [
        features.targetDependency,
        models.targetDependency,
        dependencyClients.targetDependency,
    ],
    resources: [.process("Resources")]
)
let dependencyClientsLive = SingleTargetLibrary(
    name: "DependencyClientsLive",
    dependencies: [
        dependencyClients.targetDependency,
        .product(name: "FVendors", package: "FVendors"),
    ]
)
let publicApp = SingleTargetLibrary(
    name: "PublicApp",
    dependencies: [
        features.targetDependency,
        views.targetDependency,
        dependencyClientsLive.targetDependency,
        .product(name: "FVendors", package: "FVendors"),
    ]
)

// MARK: - Package manifest

let package = Package(
    name: appName + "Package",  // To avoid target name collision when importing to Xcode project
    defaultLocalization: "en",
    platforms: [
        .iOS(.v26),
        .macOS(.v26),
    ],
    products: [
        dependencyClients.product,
        dependencyClientsLive.product,
        features.product,
        models.product,
        publicApp.product,
        views.product,
    ],
    dependencies: [
        customDump.package,
        fvendors,
    ],
    targets: [
        dependencyClients.target,
        dependencyClientsLive.target,
        features.target,
        features.testTarget,
        models.target,
        models.testTarget,
        publicApp.target,
        views.target,
        views.testTarget,
    ]
)

// MARK: - Helpers

/// Third party dependencies.
struct SourceControlDependency {
    var package: Package.Dependency
    var productName: String

    init(package: Package.Dependency, productName: String) {
        self.package = package
        self.productName = productName
    }

    var targetDependency: Target.Dependency {
        var packageName: String

        switch package.kind {
        case .fileSystem(let name, let path):
            guard let name = name ?? URL(string: path)?.lastPathComponent else {
                fatalError("No package name found. Path: \(path)")
            }
            packageName = name
        case .sourceControl(let name, let location, _):
            guard let name = name ?? URL(string: location)?.lastPathComponent else {
                fatalError("No package name found. Location: \(location)")
            }
            packageName = name
        default:
            fatalError("Unsupported dependency kind: \(package.kind)")
        }

        return .product(
            name: productName,
            package: packageName,
            moduleAliases: nil,
            condition: nil
        )
    }
}

/// Local modules.
@MainActor
struct SingleTargetLibrary {
    var name: String
    var dependencies: [Target.Dependency] = []
    var resources: [Resource]? = nil

    var product: Product {
        .library(name: name, targets: [name])
    }

    var target: Target {
        .target(name: name, dependencies: dependencies, resources: resources)
    }

    var targetDependency: Target.Dependency {
        .target(name: name)
    }

    var testTarget: Target {
        .testTarget(
            name: name + "Tests",
            dependencies: [targetDependency, customDump.targetDependency]
        )
    }
}
