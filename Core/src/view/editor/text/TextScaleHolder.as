package view.editor.text
{
	import com.kvs.ui.button.IconBtn;
	import com.kvs.utils.XMLConfigKit.StyleManager;
	import com.kvs.utils.XMLConfigKit.XMLVOMapper;
	import com.kvs.utils.XMLConfigKit.style.Style;
	
	import flash.display.Sprite;
	
	import model.ConfigInitor;
	
	import view.elementSelector.ControlPointBase;

	/**
	 * 文本输入框的型变控制器
	 */	
	public class TextScaleHolder extends Sprite
	{
		public function TextScaleHolder(editor:TextEditor)
		{
			this.editor = editor;
			
			XMLVOMapper.fuck(styleConfig, style);
			
			
			scale_up;
			scale_over;
			scale_down;
			scalePoint.iconW = scalePoint.iconH = 15;
			scalePoint.setIcons("scale_up", "scale_over", "scale_down");
			addChild(scalePoint);
			scaleControl = new ScalPointControl(this);
			
			
			width_up;
			width_over;
			width_down;
			sizePoint.iconW = sizePoint.iconH = 15;
			sizePoint.setIcons("width_up", "width_over", "width_down");
			addChild(sizePoint);
			sizeControl = new SizeControl(this);
		}
		
		/**
		 */		
		public function update():void
		{
			this.graphics.clear();
			
			style.tx =  - editor.offSet;
			style.ty =  - editor.offSet;
			style.width = editor.fieldWidth + editor.offSet * 2;
			style.height = editor.fieldHeight + editor.offSet * 2;
			
			StyleManager.drawRect(this, style, this);
			
			scalePoint.x = editor.fieldWidth + editor.offSet;
			scalePoint.y = editor.fieldHeight + editor.offSet;
			
			sizePoint.x = scalePoint.x;
			sizePoint.y = scalePoint.y / 2 + style.ty / 2;
			
			editor.stylePanel.rotation = this.rotation;
			editor.stylePanel.updateSize();
		}
		
		internal function get holderWidth():Number
		{
			return style.width;
		}
		internal function get holderHeight():Number
		{
			return style.height;
		}
		
		/**
		 * 文编辑器的尺寸变化时需同步至代理模型
		 * 
		 * 这样画布缩放和移动时就可以反向同步到文本编辑器
		 */		
		public function updateFieldToProxy():void
		{
			editor.synTextProxy();
		}
		
		/**
		 */		
		public function hide():void
		{
			this.graphics.clear();
			this.rotation = 0;
		}
		
		/**
		 */		
		internal var editor:TextEditor;
		
		/**
		 */		
		internal var sizePoint:IconBtn = new IconBtn;
		
		/**
		 */		
		private var sizeControl:SizeControl;
		
		/**
		 */		
		internal var scalePoint:IconBtn = new IconBtn;
		
		/**
		 */		
		private var scaleControl:ScalPointControl;
		
		/**
		 */		
		private var style:Style = new Style;
		
		/**
		 */		
		private var styleConfig:XML = <style>
											<border color={color} thikness='1'/>
									  </style>
		/**
		 * 缩放控制点的颜色
		 */			
		public var color:String = '#e0e0e0';
		
	}
}