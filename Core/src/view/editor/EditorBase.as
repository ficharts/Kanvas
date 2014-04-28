package view.editor
{
	import flash.display.Sprite;
	import flash.geom.Rectangle;
	
	import util.layout.LayoutTransformer;
	
	import view.element.ElementBase;
	
	/**
	 * 编辑器的基类， 编辑器负责创建或者编辑可编辑的原件
	 * 
	 * 如文本，或者其他复杂原件；
	 * 
	 * 创建和编辑会调用不同的方法，进入相应状态：创建状态或者编辑状态
	 * 
	 * 创建状态关闭时，会触发创建命令，创建一个原件；
	 * 
	 * 编辑命令关闭时，会更新当前的原件；
	 * 
	 * 编辑器的位置由每个编辑器自己控制
	 */	
	public class EditorBase extends Sprite
	{
		public function EditorBase()
		{
			super();
			
			creationMode = new CreationMode(this);
			editMode = new EditMode(this);
			
			this.hide();
		}
		
		/**
		 * 画布缩放移动时同步更新编辑器位置尺寸
		 */		
		public function updateLayout():void
		{
			
		}
		
		
		
		
		//----------------------------------------------
		//
		//
		// 控制原件创建，编辑更新的关键方法， 这些方法在不同
		//
		// 的原件编辑器中会被重写
		//
		//-----------------------------------------------
		
		/**
		 * 创建原件指令， 不同的原件需要重写此方法
		 */		
		public function createElement():void
		{
			
		}
		
		/**
		 * 更新原件属性指令，不同的原件需要重写此方法
		 */		
		public function updateElementAfterEdit():void
		{
			
		}
		
		/**
		 * 根据创建位置，尺寸信息布局编辑器
		 */		
		protected function layoutAfterCreate():void
		{
			
		}
		
		/**
		 * 将编辑器的布局信息（位置，尺寸，旋转）转换为原件的
		 */		
		protected function layoutBeforeEdit():void
		{
			
		}
		
		/**
		 */		
		public var layoutRect:Rectangle;
		
		
		
		
		
		
		//------------------------------------------
		//
		//
		// 状态控制
		//
		//
		//-------------------------------------------
		
		/**
		 * 即将创建内容， 进入创建状态
		 * 
		 * @rect, 所创建原件的位置（相对于全局坐标）
		 */		
		public function willCreate(rect:Rectangle):void
		{
			currMode = creationMode;
			this.layoutRect = rect;
			this.layoutAfterCreate();
			currMode.open();
			show();
		}
		
		/**
		 * 编辑内容，进入编辑状态
		 */		
		public function edit(element:ElementBase):void
		{
			currMode = editMode;
			currMode.open(element);
			this.layoutBeforeEdit();
			show();
		}
		
		/**
		 */		
		public function close():void
		{
			currMode.close();
			hide();
		}
		
		/**
		 */		
		protected function hide():void
		{
			this.visible = this.mouseEnabled = false;
		}
		
		
		/**
		 */		
		protected function show():void
		{
			this.visible = this.mouseChildren = true;
		}
		
		/**
		 */		
		protected var currMode:EditorModeBase;
		protected var creationMode:EditorModeBase;
		protected var editMode:EditMode;
		
		/**
		 */		
		private var _layoutTrans:LayoutTransformer; 

		/**
		 * 用于同步编辑器和文本的布局信息 
		 * 
		 * 使得编辑器布局与真实元件无缝对接；
		 */
		public function get layoutTransformer():LayoutTransformer
		{
			return _layoutTrans;
		}

		/**
		 * @private
		 */
		public function set layoutTransformer(value:LayoutTransformer):void
		{
			_layoutTrans = value;
		}

		
	}
}