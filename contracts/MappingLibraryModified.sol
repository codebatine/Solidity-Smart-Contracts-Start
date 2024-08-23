// SPDX-License-Identifier: MIT
pragma solidity 0.8.26;

contract MappingLibrary {
    struct Book {
        string title;
        uint year;
        bool exist;
    }

    // Mapping of an author to a mapping of their books.
    mapping(string => mapping(string => Book)) internal authorBooks;
    mapping(string => string[]) internal authorBookTitles;

    modifier bookDoesNotExist(string memory _author, string memory _title) {
        require(!authorBooks[_author][_title].exist, "Book exists");
        _;
    }

    modifier bookExists(string memory _author, string memory _title) {
        require(authorBooks[_author][_title].exist, "No book");
        _;
    }

    // Function to add a new book
    function addBook(
        string memory _title,
        string memory _author,
        uint _year
    ) public bookDoesNotExist(_author, _title) {
        authorBooks[_author][_title] = Book(_title, _year, true);
        authorBookTitles[_author].push(_title);

        // Emitting event
        emit BookAdded(_author, _title, _year);
    }

    // Function to get the count of books by a specific author
    function getBookCountByAuthor(
        string memory _author
    ) public view returns (uint) {
        return authorBookTitles[_author].length;
    }

    // Function to update a book's information
    function updateBook(
        string memory _author,
        string memory _oldTitle,
        string memory _newTitle,
        uint _newYear
    ) public bookExists(_author, _oldTitle) {
        if (keccak256(bytes(_oldTitle)) != keccak256(bytes(_newTitle))) {
            require(!authorBooks[_author][_newTitle].exist, "Title exists.");

            // Add the new book with the updated title and year
            authorBooks[_author][_newTitle] = Book(_newTitle, _newYear, true);

            // Delete the old book
            delete authorBooks[_author][_oldTitle];

            // Update the title in the author's book titles list
            for (uint i = 0; i < authorBookTitles[_author].length; i++) {
                if (
                    keccak256(bytes(authorBookTitles[_author][i])) ==
                    keccak256(bytes(_oldTitle))
                ) {
                    authorBookTitles[_author][i] = _newTitle;
                    break;
                }
            }
        } else {
            // Update the year if the title remains the same
            authorBooks[_author][_oldTitle].year = _newYear;
        }

        // Emitting event
        emit BookUpdated(_author, _oldTitle, _newTitle, _newYear);
    }

    // Function to delete a book
    function deleteBook(
        string memory _author,
        string memory _title
    ) public bookExists(_author, _title) {
        // Delete the book from the mapping
        delete authorBooks[_author][_title];

        // Remove the title from the author's book titles list
        for (uint i = 0; i < authorBookTitles[_author].length; i++) {
            if (
                keccak256(bytes(authorBookTitles[_author][i])) ==
                keccak256(bytes(_title))
            ) {
                authorBookTitles[_author][i] = authorBookTitles[_author][
                    authorBookTitles[_author].length - 1
                ];
                authorBookTitles[_author].pop();
                break; // Add a break here to exit the loop after deleting the title
            }
        }

        // Emitting event
        emit BookDeleted(_author, _title);
    }

    // Function to get books by author
    function getBooksByAuthor(
        string memory _author
    ) public view returns (string[] memory _titles, uint[] memory _years) {
        uint count = authorBookTitles[_author].length;

        _titles = new string[](count);
        _years = new uint[](count);

        for (uint i = 0; i < count; i++) {
            string memory title = authorBookTitles[_author][i];
            Book storage book = authorBooks[_author][title];
            _titles[i] = book.title;
            _years[i] = book.year;
        }

        return (_titles, _years);
    }

    // Events for logging changes
    event BookAdded(string indexed author, string title, uint year);
    event BookUpdated(
        string indexed author,
        string oldTitle,
        string newTitle,
        uint year
    );
    event BookDeleted(string indexed author, string title);
}
