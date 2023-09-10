import 'package:amazon_clone/common/data/constants.dart';
import 'package:amazon_clone/components/authentication/logic/blocs/auth_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddressPanel extends StatelessWidget {
  const AddressPanel({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var user =
        (BlocProvider.of<UserBloc>(context).state as UserAuthenticatedState)
            .user;

    return Container(
      height: 40,
      decoration: BoxDecoration(
          border: Border.symmetric(
              horizontal: BorderSide(
        color: Constants.selectedColor,
        width: 2.5,
      ))),
      padding: const EdgeInsets.only(left: 10),
      child: Row(
        children: [
          const Icon(
            Icons.location_on_outlined,
            size: 20,
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 5),
              child: Text(
                'Deliver to ${user.name} - ${user.address}',
                style: const TextStyle(
                  fontWeight: FontWeight.w500,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(
              left: 5,
              top: 2,
            ),
            child: Icon(
              Icons.arrow_drop_down_outlined,
              size: 18,
            ),
          )
        ],
      ),
    );
  }
}
