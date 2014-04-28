package landray.kp.maps.main.consts
{
	import landray.kp.maps.main.elements.*;
	
	import model.vo.*;
	
	public class MainConsts
	{
		public static const SHAPE_UI_MAP :XML = 
			<elements>
				<element type="circle"          voClassPath="model.vo.ShapeVO"/>
				<element type="rect"            voClassPath="model.vo.ShapeVO"/>
				<element type="arrow"           voClassPath="model.vo.ArrowVO"/>
				<element type="doubleArrow"     voClassPath="model.vo.ArrowVO"/>
				<element type="triangle"        voClassPath="model.vo.ShapeVO"/>
				<element type="stepTriangle"    voClassPath="model.vo.ShapeVO"/>
				<element type="diamond"         voClassPath="model.vo.ShapeVO"/>
				<element type="star"            voClassPath="model.vo.StarVO"/>
				<element type="line"            voClassPath="model.vo.LineVO"/>
				<element type="arrowLine"       voClassPath="model.vo.LineVO"/>
				<element type="doubleArrowLine" voClassPath="model.vo.LineVO"/>
				<element type="text"            voClassPath="model.vo.TextVO"/>
				<element type="img"             voClassPath="model.vo.ImgVO"/>
				<element type="hotspot"         voClassPath="model.vo.HotspotVO"/>
				<element type="dashRect"        voClassPath="model.vo.ShapeVO"/>
				<element type="dialog"          voClassPath="model.vo.DialogVO"/>
				<element type="camera"          voClassPath="model.vo.ElementVO"/>
				<element type="page"            voClassPath="model.vo.PageVO"/>
			</elements>;
		
		public static const SHAPE_UI:Object = 
		{
			circle         :landray.kp.maps.main.elements.Circle, 
			rect           :landray.kp.maps.main.elements.Rect, 
			arrow          :landray.kp.maps.main.elements.Arrow, 
			doubleArrow    :landray.kp.maps.main.elements.DoubleArrow, 
			triangle       :landray.kp.maps.main.elements.Triangle, 
			stepTriangle   :landray.kp.maps.main.elements.StepTriangle, 
			diamond        :landray.kp.maps.main.elements.Diamond, 
			star           :landray.kp.maps.main.elements.Star, 
			line           :landray.kp.maps.main.elements.Line, 
			arrowLine      :landray.kp.maps.main.elements.ArrowLine, 
			doubleArrowLine:landray.kp.maps.main.elements.DoubleArrowLine, 
			text           :landray.kp.maps.main.elements.Label, 
			img            :landray.kp.maps.main.elements.Image, 
			hotspot        :landray.kp.maps.main.elements.Hotspot, 
			dialog         :landray.kp.maps.main.elements.Dialog, 
			dashRect       :landray.kp.maps.main.elements.DashRect, 
			camera         :landray.kp.maps.main.elements.Camera,
			page           :landray.kp.maps.main.elements.Page
		};
	}
}