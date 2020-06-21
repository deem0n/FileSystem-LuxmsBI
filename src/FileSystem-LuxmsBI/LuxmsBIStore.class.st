Class {
	#name : #LuxmsBIStore,
	#superclass : #MemoryStore,
	#instVars : [
		'serverURL'
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
LuxmsBIStore >> initializeWithURL: anURL [
	self initialize.
	serverURL  := anURL
]

{ #category : #accessing }
LuxmsBIStore >> serverURL [
	^ serverURL
]
