Class {
	#name : #LuxmsBIFileSystemFile,
	#superclass : #MemoryFileSystemFile,
	#instVars : [
		'config',
		'shouldLoadBytes'
	],
	#category : #'FileSystem-LuxmsBI-Base'
}

{ #category : #'instance creation' }
LuxmsBIFileSystemFile class >> withConfig: aDict [
	^ self new
		config: aDict;
		basename: (aDict at: 'alt_id');
		updateSize: (aDict at: 'content_length');
		yourself
"Seems we should provide collection of bytes for bytes here, but we should make it lazily!!!!"
]

{ #category : #accessing }
LuxmsBIFileSystemFile >> config [ 
	^ config
]

{ #category : #accessing }
LuxmsBIFileSystemFile >> config: anObject [
	config := anObject
]

{ #category : #initialization }
LuxmsBIFileSystemFile >> initialize [ 
	super initialize.
	shouldLoadBytes := true.
	^ self.
]

{ #category : #accessing }
LuxmsBIFileSystemFile >> shouldLoadBytes [
	^ shouldLoadBytes
]

{ #category : #accessing }
LuxmsBIFileSystemFile >> shouldLoadBytes: anObject [
	shouldLoadBytes := anObject
]
