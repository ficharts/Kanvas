package landray.kp.view
{	
	import cn.vision.utils.ClassUtil;
	
	import flash.display.Sprite;
	
	import landray.kp.core.GRConfig;
	import landray.kp.core.KPConfig;
	import landray.kp.core.kp_internal;
	import landray.kp.utils.CoreUtil;
	
	/**
	 * Graph 所有图形类的基类，所有图形的扩展都继承自此类。
	 * 使用需要传入templete模板，传入dataProvider数据，以及指定一种theme主题样式。
	 * 
	 * @example 以下说明Graph的调用方式
	 * <listing version="3.0">
	 * var graph:Graph = new Graph;
	 * //如无必要，不需要继承GRConfig配置类
	 * graph.configClass = GRConfig;
	 * graph.templete = templete;
	 * graph.dataProvider = xmlData;
	 * graph.theme = theme;
	 * </listing>
	 */
	public class Graph
	{
		/**
		 * 构造函数。
		 * 
		 */
		public function Graph()
		{
			super();
			initialize();
		}
		
		/**
		 * @private
		 */
		private function initialize():void
		{
			__configClass = GRConfig;
			__config = new configClass(this);
		}
		
		
		/**
		 * 缩放，移动，旋转等缓动起始时的操作。
		 */
		public function flashPlay():void
		{
			
		}
		
		/**
		 * 缩放，移动，旋转等缓动结束时的操作。
		 */
		public function flashStop():void
		{
			
		}
		
		/**
		 * 缩放，移动，旋转等缓动进行时的操作。
		 */
		public function flashTrek():void
		{
			
		}
		
		
		//--------------------------------------------------------------
		// 以下属性用于传入数据
		//--------------------------------------------------------------
		
		/**
		 * 设定Graph的数据。
		 * <p>
		 * Graph类不会做任何操作，子类需要重写该setter方法以实现添加子元素操作。
		 * 
		 * @param value
		 * 
		 */
		public function set dataProvider(value:XML):void
		{
			
		}
		
		
		
		
		
		//--------------------------------------------------------------
		// 以下属性用于样式切换
		//--------------------------------------------------------------
		
		/**
		 * 设定Graph的模板。
		 * 
		 * @param value
		 * 
		 */
		public function set templete(value:XML):void
		{
			config.templete = value;
			//切换当前样式库
			CoreUtil.registLib(config.lib);
			//注册templete
			for each (var item:XML in config.templete.child('template').children()) 
				CoreUtil.registLibXMLWhole(item.@id, item, item.name().toString());
			//晴空themes map
			config.themes.clear();
			//注册themes map
			var theme:XML = XML(config.templete.child('themes').toXMLString());
			for each(item in theme.children()) 
				config.themes.put(item.name().toString(), item);
		}
		
		/**
		 * 设置graph的主题。
		 * 
		 */
		public function get theme():String
		{
			return config.theme;
		}
		
		/**
		 * @private
		 */
		public function set theme(value:String):void
		{
			config.theme = value;
			
			if (config.themes.containsKey(theme)) 
			{
				//注册当前样式库
				CoreUtil.registLib(config.lib);
				//清空partLib
				CoreUtil.clearLibPart();
				//注册partLib
				var style:XML = config.themes.getValue(theme) as XML;
				for each (var item:XML in style.children()) 
					CoreUtil.registLibXMLPart(item.@styleID, item, item.name().toString());
			}
		}
		
		
		
		
		
		//--------------------------------------------------------------
		// 以下属性管理config配置文件。
		//--------------------------------------------------------------
		
		/**
		 * 获取图形类的配置文件,会在构造函数中通过初始化生成。
		 */
		public function get config():GRConfig
		{
			return __config;
		}
		
		/**
		 * @private 
		 */
		private var __config:GRConfig;
		
		
		/**
		 * 指定config配置实例类，该类必须是GRConfig的子类,
		 * 通常在new一个Graph实例后调用,不建议在使用过程中切换该属性。
		 * 
		 * @example 以下说明了如何使用configClass。
		 * <listing version="3.0">
		 * var graph:Graph = new Graph;
		 * graph.configClass = GRConfig;
		 * </listing>
		 */
		public function get configClass():Class
		{
			return __configClass;
		}
		
		/**
		 * @private 
		 */
		public function set configClass(value:Class):void
		{
			if ((value == GRConfig) || ClassUtil.isSubClass(value, GRConfig))
			{
				__configClass = value;
				__config = new configClass(this);
			}
		}
		
		/**
		 * @private 
		 */
		private var __configClass:Class;
		
		/**
		 * 返回父级Viewer实例
		 */
		protected function get viewer():Viewer
		{
			return KPConfig.instance.kp_internal::viewer;
		}
	}
}