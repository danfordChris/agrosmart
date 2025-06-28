import 'package:ipf_flutter_starter_pack/bases.dart';

@pragma("vm:entry-point")
void _initialize() {
	WorkDispatcher._instance._register();
}

class WorkDispatcher extends BaseWorkDispatcher {
	WorkDispatcher._();
	static final WorkDispatcher _instance = WorkDispatcher._();
	static WorkDispatcher get instance => _instance;

	//TODO: Add work IDs

	@override
	void init() async {
		await workManager.initialize(_initialize);
	}

	void _register() {
		workManager.executeTask(_dispatcher);
	}

	static Future<bool> _dispatcher(String taskName, Map<String, dynamic>? inputData) async {
		//TODO: Implement according to work IDs
		return true;
	}

	//TODO: Write all work management content

}