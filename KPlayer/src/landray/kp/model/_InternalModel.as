package landray.kp.model
{
	import cn.vision.pattern.core.Model;
	
	import landray.kp.core.KPProvider;
	
	internal class _InternalModel extends Model
	{
		public function _InternalModel()
		{
			super();
			initialize();
		}
		private function initialize():void
		{
			provider  = KPProvider .instance;
		}
		public var provider:KPProvider;
	}
}