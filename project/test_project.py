import pytest
from project import author_request, book_request, author_info, parse_info


def main():
    test_book_request()
    test_author_request()
    test_author_info()
    test_parse_info_error()


def test_book_request():
    response = book_request("Pride and Prejudice", "Jane Austen")
    assert response.status_code == 200
    response = book_request("Gravity's Rainbow", "Thomas Pynchon")
    assert response.status_code == 200


def test_parse_info_error():
    response = book_request("123456", "123456")
    with pytest.raises(KeyError):
        parse_info(response)


def test_author_request():
    response = author_request("David Foster Wallace")
    assert response.status_code == 200
    response = author_request("Herman Melville")
    assert response.status_code == 200


def test_author_info():
    response = author_request("David Foster Wallace")
    assert author_info(response)[0] == ("21 February 1962")
    assert author_info(response)[1] == (["Fiction", "Interviews", "Fiction, humorous, general", "Fiction, general"])
    assert author_info(response)[2].lower() == ("infinite jest")