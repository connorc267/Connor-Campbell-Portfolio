# Book To-Be-Read List App
### Video Demo:  <URL https://youtu.be/bgGZV-yRWJ4>
### Description
#### Overview
This app offers multiple book-related functions to the user. It provides the users with the ability to look up basic information about a book they are interested in or a specific author, and allows them to create a to-be-read list, which they can view, add to, and clear through the menu of the app. There are two files for this project the main file and the unit test file.

Main menu code:
```
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
```
This menu is called in the main function of the body of the program. User are prompted to make a selection within the parameters of the menu.
```
try:
    selection = int(input("\nSelection: "))
    if (selection < 1 or selection > 6):
        print("Not a valid selection")
        continue
except ValueError:
    print("Not a valid selection")
    continue
```
Now looking at the functions of each selection. Selection 1 allows the user to search basic details of a specific book they have in mind. Once the user inputs a title and an author the program makes an API request utilizing Google Books API and returns information on the top result of the request. The program then calls another function which indexes through a JSON and returns a description of the book and the page count of the edition that is returned in the API request.

```
def book_request(title=None, author=None, results=5):
    book = requests.get(f"https://www.googleapis.com/books/v1/volumes?q=intitle:{title}+inauthor:{author}&filter=partial&maxResults={results}")
    #print(json.dumps(book.json(), indent=2))
    return book


def parse_info(info):
    info = info.json()
    try:
        descript = info["items"][0]["volumeInfo"]["description"]
        page = info["items"][0]["volumeInfo"]["pageCount"]
        return descript, page
    except KeyError:
        raise KeyError
```

Selection 2 allows the user to get general information about a specific author, including date-of-birth, top-subjects, and title of most notable work. This is accomplished through the same method of API request as the previous selection, however, Open Library's API system is utilized.

Selections 3, 4, and 5 are all related to the list making functions of the application. I decided to utilize the DictWriter function from the CSV module. When the user selects 3, the user is prompted for a title and an author, and those inputs are then stored in a CSV along with header titles.

```
def list_addition():
    title = input("Title: ")
    author = input("Author: ")
    with open("To-be-read-list.csv", "a") as file:
        writer = csv.DictWriter(file, fieldnames=["Title", "Author"])
        if (os.stat("To-be-read-list.csv").st_size == 0) == True:
            writer.writeheader()
        writer.writerow({"Title": title, "Author": author})
```
When the user selects 4 a function is called which then converts the contents of the CSV into a list of dictionaries and then outputs each dictionary in the list line by line as "[Name of title] by [Name of author]"

```
def view_list():
    list = []
    with open("To-be-read-list.csv") as file:
        reader = csv.DictReader(file)
        for row in reader:
            list.append({"Title": row["Title"], "Author": row["Author"]})

        for i in list:
            print(f"{i['Title']} by {i['Author']}")
```

Selection 5 then allows the user to erase the current TBR list.

```
def clear_list():
    with open("To-be-read-list.csv", "w+") as file:
        file.close()
```
Selection 6 closes out of the menu and program.

#### Design Choices
There were a lot of considerations to be made when designing this program. First being the layout and construction of the menu. I decided to order the menu with the API request functions first and the list making functions second. I figured that it would make more sense for the user to look up information about the book prior to adding books to a list. However, the user does have the ability to make any selection they want when the menu is shown. Another important design consideration is how the user moves back and forth from the menu to their selections. I decided to prompt the user to return to the menu after each individual selection finished its function with the prompt, "Enter yes to continue." This was a relatively simple solution and I felt that it was better than immediately continuing to the menu again because it gave the user a chance to digest the result of their previous selection before moving on. Another important design choice I made was regarding the information the program output when the user requested info on either a book or author. I decided that for the scope of this project simplicity would be better and I was also limited by the information pulled in the API requests. For the book info I felt that a description of the book and page count were the two most relevant pieces of information for the user. For the author request I wanted to include a larger list of works by the author but the API request I utilized was not pulling very accurate information after the first couple results, so I decided to limit it to just outputting the author’s top work.

#### Challenges With Testing
I found unit testing to be somewhat of a challenge with this project. It was easy to test the API requests themselves as I only needed to assert that the status code of the request equaled 200. The challenge, I found, was with testing the data that was being pulled from the API requests. Given that there are often many different editions of books it was hard to guess which edition would be pulled as the top result. This made it hard to test the page numbers and the descriptions of books. However, I did make sure to at least test my error message in a book with no result was inputted. Testing the author request was a little simpler. The author’s data of birth and top work is easy to find which makes testing the function which pulls that information more reliable. In the future I want to learn more about how to test API requests effectively, especially regarding testing a request that is then converted into a dictionary object and subsequently has data pulled from it.

#### Potential Improvements for the Future
The first improvement that comes to mind is utilizing a graphical user interface for this app. I think that the app would be more user friendly and would operate more fluidly. I think that a GUI could also greatly improve the aesthetic experience of the app. I also could add more depth to both the book and author look up functions, allowing the user to request more info and have more choices, such as allowing the user to specific ISBN or returning a greater number of an author’s works.

