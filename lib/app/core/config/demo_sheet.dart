import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';


class DemoCred {
  final String email;
  final String password;
  const DemoCred(this.email, this.password);
}

Future<void> showDemoCredSheet(
  BuildContext context, {
  required ValueChanged<DemoCred> onPick,
}) {
  const creds = <DemoCred>[
    DemoCred('sikdersaon1@gmail.com', '12345678'),
    DemoCred('admin@gmail.com', '123456789'),
  ];

  return showModalBottomSheet(
    context: context,
    isScrollControlled: false,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
    ),
    builder: (_) {
      return Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40.w,
              height: 4.h,
              margin: EdgeInsets.only(bottom: 12.h),
              decoration: BoxDecoration(
                color: Colors.black26,
                borderRadius: BorderRadius.circular(2.r),
              ),
            ),
            Text(
              'Pick a test account',
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 8.h),
            Flexible(
              child: ListView.separated(
                shrinkWrap: true,
                itemCount: creds.length,
                separatorBuilder: (_, __) => Divider(height: 1.h),
                itemBuilder: (context, i) {
                  final item = creds[i];
                  return ListTile(
                    leading: CircleAvatar(child: Text('${i + 1}')),
                    title: Text(
                      item.email,
                      style: TextStyle(fontSize: 14.sp),
                    ),
                    subtitle: Text(
                      item.password,
                      style: TextStyle(fontSize: 12.sp),
                    ),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {
                      Navigator.of(context).pop();
                      onPick(item);
                    },
                  );
                },
              ),
            ),
            SizedBox(height: 8.h),
          ],
        ),
      );
    },
  );
}
