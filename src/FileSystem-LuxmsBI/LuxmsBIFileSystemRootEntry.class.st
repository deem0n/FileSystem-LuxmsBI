Class {
	#name : #LuxmsBIFileSystemRootEntry,
	#superclass : #MemoryFileSystemDirectory,
	#category : #'FileSystem-LuxmsBI-Base'
}

{ #category : #creation }
LuxmsBIFileSystemRootEntry >> ensureCreateDatasetFromDict: aDict [
	^ self 
		fileEntryAt: (aDict at: 'schema_name')
		put: (LuxmsBIFileSystemDatasetEntry fromDict: aDict)
]
