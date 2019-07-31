# README

Build a notes application in Rails that philosophically replicates a file system

Notes can exist in any part of a hierarchy of directories, but no same file can exist in multiple directories at once.
Users in the web UI must be able to click through to add a note to a folder structure and be able to create new folders.
Users should be able to search for partial directories like Folder4 or folder5 and get a list of all files under it or any of its subdirectories.

Valid  note paths:
- /Folder1/folder4/folder5/note4
- /Folder1/folder3/note6
- /note2

(But no same note can exist in multiple directories at once)
