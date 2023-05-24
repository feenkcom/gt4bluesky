Class {
	#name : #LeBlueskySnippetViewModel,
	#superclass : #LeTextualSnippetViewModel,
	#category : #'Gt4Bluesky-Snippet'
}

{ #category : #accessing }
LeBlueskySnippetViewModel >> moveCursorAt: aCursorPosition [
]

{ #category : #accessing }
LeBlueskySnippetViewModel >> onSnippetClientChanged: anObject [
	self announce: anObject
]

{ #category : #accessing }
LeBlueskySnippetViewModel >> onSnippetPostChanged: anObject [
	self announce: anObject
]

{ #category : #accessing }
LeBlueskySnippetViewModel >> snippetElementClass [
	^ LeBlueskySnippetElement
]

{ #category : #accessing }
LeBlueskySnippetViewModel >> subscribeToSnippetModel [
	super subscribeToSnippetModel.
	
	self snippetModel weak
		when: LeBlueskySnippetClientChanged 
			send: #onSnippetClientChanged: 
			to: self.
	
	self snippetModel weak
		when: LeBlueskySnippetPostChanged 
			send: #onSnippetPostChanged: 
			to: self
]
