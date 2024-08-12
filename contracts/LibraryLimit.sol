// SPDX-License-Identifier: MIT
pragma solidity 0.8.26;

contract LibraryLimit {
    struct Book{
        string title;
        string author;
        uint16 year;
    }

    Book[5] public books;
    uint public bookcount = 0;

    function addBook(string memory _title, string memory _author, uint16 _year) public {
        books[bookcount] = Book(_title, _author, _year);
        bookcount++;
    }
}