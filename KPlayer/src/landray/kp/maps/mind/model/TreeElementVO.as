package landray.kp.maps.mind.model
{
	import landray.kp.maps.mind.view.TreeElement;
	
	public class TreeElementVO extends Object
	{
		
		public function TreeElementVO()
		{
			super();
		}
		
		/**
		 * 添加子级
		 * @param son
		 * 
		 */
		public function addSon(son:TreeElementVO):void
		{
			children.push(son);
		}
		
		/**
		 * 删除儿子
		 * @param son
		 * 
		 */
		public function deleteSon(son:TreeElement):void
		{
			try
			{
				var index:int = children.indexOf(son);
				if (index != -1)
				{
					children.splice(index, 1);
				}
				
				
			}
			catch (err:Error)
			{
				trace("TreeElement->delete" + err);
			}
		}
		
		public function set children(value:Vector.<TreeElementVO>):void 
		{
			_children = value;
		}
		
		public function get children():Vector.<TreeElementVO>
		{
			return _children;
		}
		
		public function set text(value:String):void 
		{
			_text = value;
			richText.text = value;
		}
		
		public function get text():String 
		{
			return richText.text;
		}
		
		public function set docCount(value:String):void 
		{
			_docCount = value;
			hotSopt.text = value
		}
		
		public function get docCount():String 
		{
			return hotSopt.text;
		}
		public function set id(value:String):void 
		{
			_id = value;
		}
		
		public function get id():String 
		{
			return _id;
		}
		public function set property(value:String):void 
		{
			_property = value;
		}
		
		public function get property():String 
		{
			return _property;
		}
		public function set url(value:String):void 
		{
			_url = decodeURIComponent(value);
		}
		
		public function get url():String 
		{
			return _url;
		}
		public function set visible(value:Boolean):void 
		{
			_visible = value;
		}
		
		public function get visible():Boolean 
		{
			return _visible;
		}
		//-------------------------------------------------
		
		public var x:Number = 0;
		
		public var y:Number = 0;
		
		public var height:Number = 50;
		
		public var width:Number = 50;
		
		public var level:uint = 0;
		/**
		 * 横方向
		 */
		public var hDirection:String = "right";
		
		/**
		 * 竖方向
		 */
		public var vDirection:String = "top";
		
		/**
		 * 横间距
		 */
		public var hGap:uint = 20;
		
		/**
		 * 竖间距
		 */
		public var vGap:uint = 5;
		
		/**
		 * 按钮距离
		 */
		public var btnGap:uint = 3;
		
		/**
		 * 原距离
		 */
		private var originy:int = 0;
		/**
		 * 父级VO
		 **/
		public var father:TreeElementVO = null;
		
		/**
		 * 是否显示
		 */
		private var _visible:Boolean = true;
		
		/**
		 * 文档数
		 */
		private var _docCount:String = "0";
		/**
		 * 标题
		 */
		private var _text:String = "";
		/**
		 * id
		 */
		private var _id:String = "";
		/**
		 * url
		 */
		private var _url:String = "";
		/**
		 * property
		 */
		private var _property:String = "";
		/**
		 * 展开
		 */
		public var expand:Boolean = true;
		/**
		 * 子集
		 */
		private var _children:Vector.<TreeElementVO> = new Vector.<TreeElementVO>();
		/**
		 * 底
		 */
		public var richText:RichTextVO = new RichTextVO();
		/**
		 * 红色文档数目
		 */
		public var hotSopt:RichTextVO = new RichTextVO();
		/**
		 * 线
		 */
		public var line:BezierLineVO = new BezierLineVO();
		
		
	}
}