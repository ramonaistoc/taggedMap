import 'package:flutter/material.dart';
import 'package:tagge_map/Pages/addTagPage.dart';
import 'package:tagge_map/Widgets/Tags/TagList_CreateTag.dart';
import 'package:tagge_map/Widgets/Tags/createTagContainer.dart';

class TagList extends StatefulWidget {
  @override
  _TagListState createState() => _TagListState();
}

class _TagListState extends State<TagList> {
  @override
  Widget build(BuildContext context) {
    Function deleteTag = AddTagPageProvider.of(context)
        .removeTag; // vectorul meu cu taguri text-culoare

    List<Tag> locationTags = AddTagPageProvider.of(context)
        .getTags(); // vectorul meu cu taguri text-culoare
    List<CreateTagContainer> locationTagContainer = [];
    // Function addTag = AddTagPageProvider.of(context).addTag;

    for (var x = 0; x < locationTags.length; x++) {
      print(locationTags[x].tagText);
      print(locationTags[x].id);
      locationTagContainer.add(
        CreateTagContainer(locationTags[x].id, locationTags[x].tagText,
            locationTags[x].tagColor, () {
          deleteTag(locationTags[x].tagText, locationTags[x].tagColor);
        }, () {
          // addTag(locationTags[x]);
        }),
      );
    }

    Widget yourTags = Container(
      width: 0.9 * MediaQuery.of(context).size.width,
      padding: EdgeInsets.only(left: 12),
      height: 36,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            "You can describe this place however you want",
            style: TextStyle(
              color: Colors.grey[500],
            ),
          ),
        ],
      ),
    );
    if (locationTagContainer.length > 0) {
      yourTags = Container(
        // padding: EdgeInsets.only(left: 20),
        height: 36.0,
        width: 0.9 * MediaQuery.of(context).size.width,
        child: ListView(
          scrollDirection: Axis.horizontal,
          children: locationTagContainer,
        ),
      );
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Column(
          children: <Widget>[
            // Padding(
            //   padding: EdgeInsets.only(
            //     left: 20.0,
            //     top: 6,
            //     bottom: 6,
            //   ),
            // child:
            Container(
              width: 1 * MediaQuery.of(context).size.width,
              padding: EdgeInsets.only(left: 20),
              child: Flexible(
                child: Text(
                  "Describe your experience",
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
            SizedBox(height: 15),
            yourTags,
            SizedBox(height: 10),
          ],
        ),
      ],
    );
  }
}
