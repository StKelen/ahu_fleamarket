import 'package:flutter/material.dart';

import 'package:flea_market/common/config/routes.dart';
import 'package:flea_market/common/config/service_url.dart';
import 'package:flea_market/common/config/theme.dart';
import 'package:flea_market/routers/index.dart';

class ListItem extends StatelessWidget {
  final int did;
  final String image;
  final String title;
  final dynamic price;
  final String avatar;
  final String nickname;
  final String building;
  ListItem(this.did, this.image, this.title, this.price, this.avatar,
      this.nickname, this.building,
      {Key key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            offset: Offset(2, 3),
            color: Color(0x44B2AEC1),
            blurRadius: 3,
          )
        ],
        borderRadius: BorderRadius.circular(10),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: InkWell(
          onTap: () {
            MyRouter.router
                .navigateTo(context, RoutesPath.detailPage + '?did=$did');
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.network(ServiceUrl.uploadImageUrl + '/$image'),
              Text(
                title,
                maxLines: 2,
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: Themes.textPrimaryColor),
              ),
              Text(
                '¥$price',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    height: 2,
                    color: Colors.redAccent),
              ),
              Container(
                margin: EdgeInsets.only(top: 10),
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                    border: Border(
                        top: BorderSide(width: 0.5, color: Colors.black12))),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        CircleAvatar(
                          radius: 14,
                          backgroundImage: NetworkImage(
                              ServiceUrl.uploadImageUrl + '/$avatar'),
                        ),
                        SizedBox(width: 5),
                        Text(
                          nickname,
                          style: TextStyle(color: Colors.black54, fontSize: 18),
                        )
                      ],
                    ),
                    Text(
                      building,
                      style: TextStyle(color: Colors.black38),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
