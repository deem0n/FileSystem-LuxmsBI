"
This package contains the Luxms BI resources implementation of Pharo's FileSystem manager. 

It make it possible to look over Luxms BI resources via network.
"
Class {
	#name : #ManifestFileSystemLuxmsBI,
	#superclass : #PackageManifest,
	#category : #'FileSystem-LuxmsBI-Manifest'
}

{ #category : #'code-critics' }
ManifestFileSystemLuxmsBI class >> ruleRBMethodSourceContainsLinefeedsRuleV1FalsePositive [
	^ #(#(#(#RGMethodDefinition #(#LuxmsBIStore #initializeWithURL: #false)) #'2020-06-21T23:53:05.677032+03:00') )
]
