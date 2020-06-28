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

{ #category : #creation }
LuxmsBIFileSystemDatasetEntry >> ensureCreateFileFromDict: aDict [
	^ self 
		fileEntryAt: (aDict at: 'alt_id') 
		put: (LuxmsBIFileSystemFile withConfig: aDict)
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
