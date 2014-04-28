package util.layout
{
	import com.kvs.utils.MathUtil;
	import com.kvs.utils.PointUtil;
	
	import flash.display.Sprite;
	import flash.geom.Point;
	
	import model.vo.ElementVO;
	
	import util.LayoutUtil;
	
	import view.element.ElementBase;
	import view.element.shapes.LineElement;

	/**
	 * 画布坐标与stage坐标的转换器
	 */	
	public class LayoutTransformer
	{
		/**
		 */		
		public function LayoutTransformer(canvas:Sprite)
		{
			this.canvas = canvas;
		}
		
		/**
		 * 根据元素VO获取页面镜头信息，包括镜头宽高，旋转角度，
		 */		
		public function getLayoutInfo(ele:ElementBase):ElementVO
		{
			var matr:ElementVO = new ElementVO;
			
			var point:Point = LayoutUtil.elementPointToStagePoint(ele.x, ele.y, canvas);
			
			matr.x = point.x;
			matr.y = point.y;
			matr.width = ele.scaledWidth * canvasScale;
			matr.height = ele.scaledHeight * canvasScale;
			matr.rotation = ele.rotation;
			
			if (ele is LineElement)
				matr.width = matr.width / 2;
			
			if (matr.width / matr.height > 4 / 3)
			{
				var newH:Number = matr.width * 3 / 4;
				matr.height = newH;
			}
			else
			{
				var newW:Number = matr.height * 4 / 3;
				matr.width = newW;
			}
			
			return matr;
		}
		
		/**
		 * 画布比例的补充比例，让元素抵消画布缩放影响，随时随地原生态
		 */		
		public function get compensateScale():Number
		{
			return 1 / canvas.scaleX;
		}
		
		/**
		 * 图形比例抵消画布比例补位后，得到的实际比例
		 */		
		public function getStageScaleFromElement(scale:Number):Number
		{
			return scale / this.compensateScale;
		}
		
		/**
		 * 将舞台比例转化为元素的最终比例
		 */		
		public function getElementScaleByStageScale(scale:Number):Number
		{
			return scale * compensateScale;
		}
		
		/**
		 * 将舞台上间距转化为画布上的间距
		 */		
		public function stageDisToCanvasDis(dis:Number):Number
		{
			return dis / canvasScale;
		}
		
		/**
		 * 画布比例
		 */		
		public function get canvasScale():Number
		{
			return canvas.scaleX;
		}
		
		/**
		 */		
		public var canvas:Sprite;
	}
}