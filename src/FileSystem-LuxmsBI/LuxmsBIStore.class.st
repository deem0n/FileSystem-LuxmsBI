Class {
	#name : #LuxmsBIStore,
	#superclass : #MemoryStore,
	#instVars : [
		'serverURL',
		'httpClient',
		'username',
		'password'
	],
	#category : #'FileSystem-LuxmsBI-Base'
}

{ #category : #'as yet unclassified' }
LuxmsBIStore class >> serverURL: anURL [
	^ self basicNew
		initializeWithURL: anURL
		yourself
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
				ensureCreateDirectory: (hash at: 'schema_name') ]
]

{ #category : #printing }
LuxmsBIStore >> forReferencePrintOn: aStream [
	aStream nextPutAll: self serverURL asString 
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
