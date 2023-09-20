## Book TBR list application ##

import requests
import csv
import os


def main():
    while True:
        print()
        menu()
        try:
            selection = int(input("\nSelection: "))
            if selection < 1 or selection > 6:
                print("Not a valid selection")
                continue
        except ValueError:
            print("Not a valid selection")
            continue

        if selection == 1:
            print("\nInput a title and author.\n")
            title = input("Title: ")
            author = input("Author: ")
            results = 1
            info = book_request(title, author, results)
            try:
                des, page = parse_info(info)
            except KeyError:
                print("\nInvalid Input")
                continue
            print("\nHere is a description of the book:\n")
            print(des)
            print()
            print(
                "Pages:",
                page,
            )
            print()
            x = input("Enter yes to continue ")
            if x == "yes":
                continue
            else:
                break

        elif selection == 2:
            author = input("\nAuthor: ")
            name = author_request(author)
            try:
                birthdate, top_subjects, top_work = author_info(name)
            except IndexError:
                print("\nNot a valid input\n")
                continue
            print(f"Birthdate: {birthdate}")
            print(f"Top Subjects: {top_subjects}")
            print(f"Top Work: {top_work}")

            x = input("Enter yes to continue ")
            if x == "yes":
                continue
            else:
                break

        elif selection == 3:
            list_addition()
            continue

        elif selection == 4:
            print()
            print("TBR List")
            view_list()
            print()
            x = input("Enter yes to continue ")
            if x == "yes":
                continue
            else:
                break

        elif selection == 5:
            clear_list()
            continue

        elif selection == 6:
            print()
            break


def menu():
    print("Main Menu")
    print("#################################################")
    print("[1] Book info look-up")
    print("[2] Info about a specific author?")
    print("[3] Add a book to to-be-read-list")
    print("[4] View to-be-read-list")
    print("[5] Clear List")
    print("[6] Close menu")
    print("#################################################")


def book_request(title=None, author=None, results=5):
    book = requests.get(
        f"https://www.googleapis.com/books/v1/volumes?q=intitle:{title}+inauthor:{author}&filter=partial&maxResults={results}"
    )
    # print(json.dumps(book.json(), indent=2))
    return book


def parse_info(info):
    info = info.json()
    try:
        descript = info["items"][0]["volumeInfo"]["description"]
        page = info["items"][0]["volumeInfo"]["pageCount"]
        return descript, page
    except KeyError:
        raise KeyError


def author_request(author):
    name_request = requests.get(
        f"https://openlibrary.org/search/authors.json?q={author}"
    )
    # print(json.dumps(name_request.json(), indent=2))
    return name_request


def author_info(name):
    name = name.json()
    birthdate = name["docs"][0]["birth_date"]
    top_subjects = name["docs"][0]["top_subjects"][0:4]
    top_work = name["docs"][0]["top_work"]
    return birthdate, top_subjects, top_work


def list_addition():
    title = input("Title: ")
    author = input("Author: ")
    with open("To-be-read-list.csv", "a") as file:
        writer = csv.DictWriter(file, fieldnames=["Title", "Author"])
        if (os.stat("To-be-read-list.csv").st_size == 0) == True:
            writer.writeheader()
        writer.writerow({"Title": title, "Author": author})


def view_list():
    list = []
    with open("To-be-read-list.csv") as file:
        reader = csv.DictReader(file)
        for row in reader:
            list.append({"Title": row["Title"], "Author": row["Author"]})

        for i in list:
            print(f"{i['Title']} by {i['Author']}")


def clear_list():
    with open("To-be-read-list.csv", "w+") as file:
        file.close()


if __name__ == "__main__":
    main()
