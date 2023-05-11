Class {
	#name : #LeBlueskySnippetElement,
	#superclass : #LeSnippetElement,
	#instVars : [
		'formElement'
	],
	#category : #'Gt4Bluesky-Model'
}

{ #category : #accessing }
LeBlueskySnippetElement >> initialize [
	| form |
	super initialize.
	form := GtApLoginForm new
			clientCallback: [ :aClient :anElement | anElement phlow spawnObject: (GtApUser new client: aClient) ].
	formElement := form asGtMagritteViewModel asElement margin: (BlInsets all: 10).
]

{ #category : #accessing }
LeBlueskySnippetElement >> snippetContent [
	^ formElement
]

{ #category : #accessing }
LeBlueskySnippetElement >> snippetToolbar [
	^ nil
]
