Extension { #name : #FileSystem }

{ #category : #'*FileSystem-LuxmsBI' }
FileSystem class >> luxmsbi: anURL [
	^ self store: (LuxmsBIStore serverURL: anURL)
]
