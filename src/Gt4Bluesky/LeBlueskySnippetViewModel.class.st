Class {
	#name : #LeBlueskySnippetViewModel,
	#superclass : #LeSnippetViewModel,
	#instVars : [
		'blueskySnippet'
	],
	#category : #'Gt4Bluesky-Model'
}

{ #category : #accessing }
LeBlueskySnippetViewModel >> blueskySnippetModel: aSnippet [
	blueskySnippet := aSnippet
]

{ #category : #accessing }
LeBlueskySnippetViewModel >> initialize [
	super initialize.
]

{ #category : #accessing }
LeBlueskySnippetViewModel >> snippetElementClass [
	^ LeBlueskySnippetElement
]

{ #category : #accessing }
LeBlueskySnippetViewModel >> snippetModel [
	^ blueskySnippet 
]
