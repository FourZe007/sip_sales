import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sip_sales_clean/core/constant/enum.dart';

class NavbarCubit extends Cubit<NavbarType> {
  NavbarCubit() : super(NavbarType.home);

  void changeNavbarType(int index) {
    switch (index) {
      case 0:
        emit(NavbarType.home);
        break;
      case 1:
        emit(NavbarType.report);
        break;
      case 2:
        emit(NavbarType.profile);
        break;
      default:
        emit(NavbarType.home);
    }
  }
}
