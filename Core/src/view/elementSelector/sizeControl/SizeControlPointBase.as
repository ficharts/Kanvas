package view.elementSelector.sizeControl
{
	import com.kvs.ui.clickMove.ClickMoveControl;
	import com.kvs.ui.clickMove.IClickMove;
	
	import model.vo.ElementVO;
	import model.vo.PageVO;
	
	import modules.pages.PageUtil;
	
	import view.element.PageElement;
	import view.elementSelector.ElementSelector;
	
	/**
	 * 图形尺寸缩放控制点的基类
	 */	
	public class SizeControlPointBase implements IClickMove
	{
		public function SizeControlPointBase(holder:ElementSelector)
		{
			this.holder = holder;
		}
		
		/**
		 */		
		protected var moveControl:ClickMoveControl;
		
		/**
		 */		
		protected var holder:ElementSelector;
		
		/**
		 */		
		public function moveOff(xOff:Number, yOff:Number):void
		{
		}
		
		/**
		 */		
		public function clicked():void
		{
		}
		
		/**
		 */		
		public function startMove():void
		{
			//holder.element.disable();
			oldDis = holder.curRDis;
			
			oldX = holder.x;
			oldY = holder.y;
			
			if (holder.element.isPage)
				holder.coreMdt.pageManager.registUpdateThumbVO(holder.element.vo.pageVO);
		}
		
		/**
		 */		
		public function stopMove():void
		{
			//holder.element.enable();
			holder.coreMdt.autoAlignController.clear();
		}
		
		/**
		 * 图形重绘后，刷新型变控制器布局
		 */		
		protected function updateHolderLayout():void
		{
			holder.layoutInfo.update();
			holder.x = holder.layoutInfo.x;
			holder.y = holder.layoutInfo.y;
			holder.render();
			
			
		}
		
		/**
		 *  图形角度与鼠标角度（光标与图形中心点连线所形成的角度）插值，弧度单位
		 */		
		protected function get roteShapeWithMouse():Number
		{
			return (holder.rotation - holder.currentRote) / 180 * Math.PI;
		}
		
		/**
		 * 
		 * 光标点到直线的距离，此直线经过图形原坐标点
		 * 
		 * @param rad 直线的旋转弧度；
		 * 
		 * 光标到此直线的距离与图形尺寸拉伸对应；
		 * 
		 * 如果弧度值为图形旋转弧度， 得出的距离影响图形的高度；
		 * 
		 * 弧度值为图形旋转弧度 - PI / 2， 得出的距离影响图形的宽度 
		 * 
		 */				
		protected function getDisFromMpToLine(rad:Number):Number
		{
			var tan:Number = Math.tan(rad);
			return  (- holder.getMpToY(oldY) + tan * holder.getMpToX(oldX)) / Math.sqrt(tan * tan + 1);
		}
		
		/**
		 * 当前图形角度的弧度值
		 */		
		protected function get curRad():Number
		{
			return holder.rotation / 180 * Math.PI
		}
		
		/**
		 */		
		protected var oldSize:Number = 0;
		
		/**
		 */		
		protected var oldDis:Number = 0;
		
		/**
		 */		
		protected var oldY:Number = 0;
		
		/**
		 */		
		protected var oldX:Number = 0;
			
		/**
		 */	
		protected var oldVO:ElementVO;
	}
}