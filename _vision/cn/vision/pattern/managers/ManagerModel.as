package cn.vision.pattern.managers
{
	import cn.vision.core.VSEventDispatcher;
	import cn.vision.core.vs;
	import cn.vision.events.EventModel;
	import cn.vision.pattern.core.Model;
	
	public class ManagerModel extends Manager
	{
		public  static const instance:ManagerModel = new ManagerModel;
		private static var   created :Boolean;
		public function ManagerModel()
		{
			if(!created) {
				created = true;
				super();
				quene = [];
			} else throw new Error("Single Ton!");
		}
		
		public function push($model:Model):void
		{
			//model不为空将其加入队列
			if ($model) { quene.push($model); }
		}
		
		public function execute($model:Model=null):void
		{
			//model不为空将其加入队列
			if ($model) { quene.push($model); }
			
			if (quene.length) {
				if (!running) {
					//非运行状态下,进入运行状态,并且开始加载模型进程
					vs::running = true;
					executeModel();
					//调用queneStart
					queneStart();
				}
			} else queneEnd();
		}
		
		protected function executeModel():void
		{
			current = Model(quene.shift());
			current.addEventListener(EventModel.UPDATE_START, updateStartHandler);
			current.addEventListener(EventModel.UPDATE_END  , updateEndHandler  );
			current.execute();
		}
		
		protected function updateStartHandler(e:EventModel):void
		{
			current.removeEventListener(EventModel.UPDATE_START, updateStartHandler);
			stepStart();
		}
		protected function updateEndHandler  (e:EventModel):void
		{
			current.removeEventListener(EventModel.UPDATE_END  , updateEndHandler  );
			stepEnd();
			if (quene.length) {
				executeModel();
			} else {
				vs::running = false;
				queneEnd();
			}
		}
		
		public function get running():Boolean
		{
			return Boolean(vs::running);
		}
		vs var running:Boolean;
		
		private var current:Model;
		private var quene:Array;
	}
}