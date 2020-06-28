"
I am specific store for the Luxms BI FileSystem
"
Class {
	#name : #LuxmsBIStore,
	#superclass : #MemoryStore,
	#instVars : [
		'serverURL',
		'httpClient',
		'username',
		'password'
	],
	#category : #'FileSystem-LuxmsBI-Store'
}

{ #category : #'as yet unclassified' }
LuxmsBIStore class >> serverURL: anURL [
	^ self basicNew
		initializeWithURL: anURL
		yourself
]

{ #category : #private }
LuxmsBIStore >> basicEntry: directoryEntry path: aPath nodesDo: aBlock [
	"directory entry might be LuxmsBIFileSystemdatasetEntry"

	(directoryEntry
		isKindOf:
			(self class environment at: #LuxmsBIFileSystemDatasetEntry))
		ifTrue: [ directoryEntry shouldLoadEntries
				ifTrue: [ self loadDatasetResourcesFor: directoryEntry ] ].
	directoryEntry fileEntriesDo: aBlock
]

{ #category : #private }
LuxmsBIStore >> basicOpen: path writable: aBoolean [
	^ self
		nodeAt: path
		ifPresent: [ :aMemoryFileSystemEntry | "LuxmsBIFile" 
			self downloadContentFor: aMemoryFileSystemEntry withPath: path ]
		ifAbsent: [ aBoolean
				ifFalse: [ self signalFileDoesNotExist: path ]
				ifTrue: [ self createFile: path ] ]
]

{ #category : #initialization }
LuxmsBIStore >> downloadContentFor: aLuxmsBIFileSystemFile withPath: path [
	| response |
	aLuxmsBIFileSystemFile shouldLoadBytes ifFalse: [^ aLuxmsBIFileSystemFile basicOpen; yourself ].
	
	response := httpClient
		url: serverURL;
		timeout: 20;
		addPath: '/srv/resources', (path pathString);
		get;
		response.
	httpClient isSuccess
		ifTrue: [	aLuxmsBIFileSystemFile shouldLoadBytes: false; updateContents: (response entity bytes)].
	^ aLuxmsBIFileSystemFile.
]

{ #category : #initialization }
LuxmsBIStore >> fillRootDir [
	| response datasets |
	response := httpClient
		url: serverURL;
		timeout: 20;
		addPath: '/api/db/adm.datasets';
		get;
		response.
	httpClient isSuccess
		ifFalse: [ ^ self ].
	datasets := NeoJSONReader fromString: response entity string.
	datasets
		do: [ :hash | 
			self root
				ensureCreateDatasetFromDict: hash ]
]

{ #category : #printing }
LuxmsBIStore >> forReferencePrintOn: aStream [
	aStream nextPutAll: self serverURL asString 
]

{ #category : #initialization }
LuxmsBIStore >> initialize [
	"comment stating purpose of instance-side message"
	"scope: class-variables  &  instance-variables"	
			
	| |
	super initialize.
	"We should create specific entries as children of root"
	root := LuxmsBIFileSystemRootEntry new.
]

{ #category : #initialization }
LuxmsBIStore >> initializeWithURL: anURL [
	"can accept String and Url"

	| response |
	self initialize.
	serverURL := anURL asUrl.
	httpClient := ZnClient new.
	response := self login.
	response statusLine code = 200 ifFalse: [ ^ self ].
	self fillRootDir.
]

{ #category : #initialization }
LuxmsBIStore >> loadDatasetResourcesFor: datasetDirectoryEntry [ 
	| response resources |
	response := httpClient
		url: serverURL;
		timeout: 20;
		addPath: '/api/db/', (datasetDirectoryEntry basename), '.resources';
		get;
		response.
	httpClient isSuccess
		ifFalse: [ ^ self ].
	resources := NeoJSONReader fromString: response entity string.
	resources
		do: [ :hash | 
			datasetDirectoryEntry
				ensureCreateFileFromDict: hash].
	datasetDirectoryEntry shouldLoadEntries: false.
]

{ #category : #initialization }
LuxmsBIStore >> login [
	"should return username and isAdmin?"

	| response |
	response := httpClient
		url: serverURL;
		timeout: 20;
		addPath: '/api/auth/login';
		formAt: 'username' put: self provideUsername;
		formAt: 'password' put: self providePassword;
		post;
		response.
	httpClient isSuccess
		ifTrue: [ ^ response ].
	response statusLine code = 403
		ifTrue: [ (UIManager default
				confirm: 'Wrong login or password. Try another one?')
				ifTrue: [ ^ self login ] ].
	[ UIManager default inform: response entity string ].
	^ response
]

{ #category : #initialization }
LuxmsBIStore >> providePassword [
	"Probably we shouldn't keep username in the instancevar..."

	password := UIManager default
				requestPassword: 'Password for ' , self serverURL asString.
	^ password
]

{ #category : #initialization }
LuxmsBIStore >> provideUsername [
	"Probably we shouldn't keep username in the instancevar..."

	username := UIManager default
				request: 'Username for ' , self serverURL asString initialAnswer: username.
	^ username
]

{ #category : #accessing }
LuxmsBIStore >> serverURL [
	^ serverURL
]
