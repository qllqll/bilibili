import 'package:bilibili/db/hi_cache.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

///单元测试
void main() {
  test('测试HiCache', () async {
    TestWidgetsFlutterBinding.ensureInitialized();
    //模拟运行环境
    SharedPreferences.setMockInitialValues({});
    await HiCache.preInit();
    var key = 'testHiCache', value = 'hello';
    HiCache.getInstance().setString(key, value);
    expect(HiCache.getInstance().get(key), value);
  });
}
