package view.elementSelector.sizeControl
{
	import com.kvs.utils.XMLConfigKit.style.Style;
	
	import flash.display.Sprite;
	
	import view.elementSelector.ControlPointBase;
	import view.elementSelector.ElementSelector;
	import view.elementSelector.IPointControl;
	
	/**
	 */	
	public class SizeControl extends Sprite implements IPointControl
	{
		public function SizeControl(selector:ElementSelector)
		{
			super();
			
			this.selector = selector;
			//上下左右通用尺寸拉伸控制点
			tp.styleConfig = sizePointStyle;
			bp.styleConfig = sizePointStyle;
			lp.styleConfig = sizePointStyle;
			rp.styleConfig = sizePointStyle;
			
			tpControl = new TopPointControl(selector, tp);
			addChild(tp);
			
			bpControl = new BottomPointControl(selector, bp);
			addChild(bp);
			
			lpControl = new LeftPointControl(selector, lp);
			addChild(lp);
			
			rpControl = new RightPointControl(selector, rp);
			addChild(rp);
		}
		
		/**
		 */		
		public function layout(style:Style):void
		{
			if (visible)
			{
				tp.x = 0;
				tp.y = style.ty;
				
				bp.x = 0;
				bp.y = style.height / 2;
				
				lp.x = style.tx;
				lp.y = 0;
				
				rp.x = style.width / 2;
				rp.y = 0;
			}
		}
		
		/**
		 * 上方
		 */		
		private var tpControl:SizeControlPointBase;
		
		/**
		 * 下方拉伸控制器
		 */		
		private var bpControl:SizeControlPointBase;
		
		/**
		 * 左方拉伸控制器 
		 */		
		private var lpControl:SizeControlPointBase;
		
		/**
		 * 右方拉伸控制器 
		 */		
		private var rpControl:SizeControlPointBase;
		
		/**   
		 * 向上尺寸拉伸控制点
		 */		
		public var tp:ControlPointBase = new ControlPointBase;
		
		/**   
		 * 向下尺寸拉伸控制点
		 */		
		public var bp:ControlPointBase = new ControlPointBase;
		
		/**   
		 * 向左尺寸拉伸控制点
		 */		
		public var lp:ControlPointBase = new ControlPointBase;
		
		/**   
		 * 向右尺寸拉伸控制点
		 */		
		public var rp:ControlPointBase = new ControlPointBase;
		
		/**
		 */		
		private var selector:ElementSelector;
		
		/**
		 * 原始尺寸缩放控制点的样式
		 */			
		private var sizePointStyle:XML = <states>
											<normal tx='-5' ty='-5' width='10' height='10' radius='5'>
												<border color='#DDDDDD' thickness='1' alpha='1' pixelHinting='false'/>
												<fill color='#FFFFFF' alpha='1'/>
											</normal>
											<hover tx='-6' ty='-6' width='12' height='12' radius='6' >
												<border color='#CCCCCC' thickness='1' pixelHinting='false'/>
												<fill color='#DDDDDD' alpha='1'/>
											</hover>
											<down tx='-6' ty='-6' width='12' height='12' radius='6'>
												<border color='#DDDDDD' thickness='1' pixelHinting='false'/>
												<fill color='#DDDDDD' alpha='0.7'/>
											</down>
										</states>
	}
}