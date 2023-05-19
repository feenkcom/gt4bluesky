Class {
	#name : #LeBlueskySnippetViewModel,
	#superclass : #LeTextualSnippetViewModel,
	#category : #'Gt4Bluesky-Snippet'
}

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
	^ LeBlueksySnippetElement
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
