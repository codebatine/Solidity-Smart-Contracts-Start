// SPDX-License-Identifier: MIT
pragma solidity 0.8.26;

contract LIbrary {

struct Book{
    string title;
    string author;
    uint16 year;
}
    Book[] public books;

    function addBook(string memory _title, string  memory _author, uint16 _year) public {
        books.push(Book(_title, _author, _year));
    }

    function bookCount() public view returns(uint) {
        return books.length;
    }

    function removeBook(uint _index) public {
        require(_index < books.length,  "The index doesn't exist.");
        delete books[_index];
    }

    function removeBookIndex(uint _index) public {
        require(_index < books.length, "The index doesn't exist.");
        books[_index] = books[books.length - 1];
        books.pop();

}}