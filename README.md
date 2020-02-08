# Full Screen image

Full screen photo viewer. It shuts off when scrolling vertically. Can work with Hero widget

<img src="https://raw.githubusercontent.com/Furkankyl/full_screen_image/master/screen.png" width="35%" />   

## Installation

To use this plugin, add full_screen_image as a [dependency in your pubspec.yaml file.](https://flutter.dev/docs/development/packages-and-plugins/using-packages)

```bash
full_screen_image: any
```

## Getting Started
Check out the [example](https://github.com/Furkankyl/full_screen_image/tree/master/example) app using full_screen_image.

# Flutter

#### Full screen image:
<img src="https://raw.githubusercontent.com/Furkankyl/full_screen_image/master/1.gif" width="35%" />   

``` dart
  FullScreenWidget(
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Image.asset(
            "assets/image1.jpg",
            fit: BoxFit.cover,
          ),
        ),
      )

```

#### Full screen with hero:
<img src="https://raw.githubusercontent.com/Furkankyl/full_screen_image/master/2.gif" width="35%" />   

``` dart
FullScreenWidget(
        child: Hero(
          tag: "customTag",
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Image.asset(
              "assets/image2.jpg",
              fit: BoxFit.cover,
            ),
          ),
        ),
      );

```
#### Small image:
if you don't want widget full screen then use center widget
 <br>
<img src="https://raw.githubusercontent.com/Furkankyl/full_screen_image/master/3.gif" width="35%" />
``` dart
 FullScreenWidget(
        child: Center(
          child: Hero(
            tag: "smallImage",
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.asset(
                "assets/image3.jpg",
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
      );
```
#### Custom background color:
<img src="https://raw.githubusercontent.com/Furkankyl/full_screen_image/master/4.gif" width="35%" />   

``` dart
FullScreenWidget(
        backgroundColor: Colors.purple,
        child: Center(
          child: Hero(
            tag: "customBackground",
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.asset(
                "assets/image3.jpg",
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
      );

```
#### Non transparent widget:
<img src="https://raw.githubusercontent.com/Furkankyl/full_screen_image/master/5.gif" width="35%" />   

``` dart
FullScreenWidget(
        backgroundColor: Colors.purple,
        backgroundIsTransparent: false,
        child: Center(
          child: Hero(
            tag: "nonTransparent",
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.asset(
                "assets/image3.jpg",
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
      );

```
#### Custom widget:
<img src="https://raw.githubusercontent.com/Furkankyl/full_screen_image/master/6.gif" width="35%" />   

``` dart
  FullScreenWidget(
        child: SafeArea(
          child: Card(
            elevation: 4,
            child: Container(
              height: 350,
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: <Widget>[
                  Hero(
                    tag: "customWidget",
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Image.asset(
                        "assets/image3.jpg",
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  Text('Lorem text',style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),),
                  SizedBox(
                    height: 16,
                  ),
                  Expanded(
                    child: Text(
                      lorem,
                    ),
                  ),

                ],
              ),
            ),
          ),
        ),
      );

```

## License
[Apache](https://github.com/Furkankyl/full_screen_image/blob/master/LICENSE)
