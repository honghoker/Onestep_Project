const functions = require('firebase-functions');
const admin = require('firebase-admin');
const algoliasearch = require('algoliasearch');

const ALGOLIA_ID = '059Q7MU1OH';
const ALGOLIA_ADMIN_KEY = '4ea45dbd9a081a415d32688698e8c451';
const ALGOLIA_SEARCH_KEY = '43560027b704200d3379c8913005028b';

const ALGOLIA_INDEX_NAME = 'notes';
const client = algoliasearch(ALGOLIA_ID, ALGOLIA_ADMIN_KEY);

// Update the search index every time a blog post is written.
exports.onNoteCreated = functions.firestore.document('products/{productsId}').onCreate((snap, context) => {
    // Get the note document
    const note = snap.data();
  
    // Add an 'objectID' field which Algolia requires
    // note.objectID = context.params.noteId;
    note.objectID = context.params.noteId;
  
    // Write to the algolia index
    const index = client.initIndex(ALGOLIA_INDEX_NAME);
    return index.saveObject(note);
  });
