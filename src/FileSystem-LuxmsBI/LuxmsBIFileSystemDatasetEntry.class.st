Class {
	#name : #LuxmsBIFileSystemDatasetEntry,
	#superclass : #MemoryFileSystemDirectory,
	#instVars : [
		'title',
		'config',
		'shouldLoadEntries'
	],
	#category : #'FileSystem-LuxmsBI-Base'
}

{ #category : #'instance creation' }
LuxmsBIFileSystemDatasetEntry class >> fromDict: dict [
	
	^ self new
		basename: (dict at: 'schema_name');
		title: (dict at: 'title');
		config: dict;
		shouldLoadEntries: true;
		yourself
]

{ #category : #accessing }
LuxmsBIFileSystemDatasetEntry >> config [
	^ config
]

{ #category : #accessing }
LuxmsBIFileSystemDatasetEntry >> config: anObject [
	config := anObject
]

{ #category : #enumeration }
LuxmsBIFileSystemDatasetEntry >> fileEntriesDo: aBlock [
	"base class doesn't use self entries, so we have no chance to catch the behaviour"
	self entries keys sort do: [ :fileName|
		aBlock value: (entries at: fileName)].
]

{ #category : #accessing }
LuxmsBIFileSystemDatasetEntry >> shouldLoadEntries [
	^ shouldLoadEntries
]

{ #category : #accessing }
LuxmsBIFileSystemDatasetEntry >> shouldLoadEntries: anObject [
	shouldLoadEntries := anObject
]

{ #category : #accessing }
LuxmsBIFileSystemDatasetEntry >> title [
	^ title
]

{ #category : #accessing }
LuxmsBIFileSystemDatasetEntry >> title: anObject [
	title := anObject
]
