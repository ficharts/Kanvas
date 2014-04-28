package landray.kp.core
{
	public class KPEmbeds
	{
		public  static const instance:KPEmbeds = new KPEmbeds;
		private static var   created :Boolean;
		public function KPEmbeds()
		{
			if(!created) 
			{
				created = true;
				super();
			} 
			else 
			{
				throw new Error("Single Ton!");
			}
		}
		
		public var styleTips:XML = 
			<label hPadding='12' vPadding='8' radius='30' vMargin='10' hMargin='20'>
				<border thikness='1' alpha='0' color='555555' pixelHinting='true'/>
				<fill color='e96565' alpha='0.9'/>
				<format font='微软雅黑' size='13' color='ffffff'/>
				<text value='${tips}' substr='2000'>
					<effects>
						<shadow color='0' alpha='0.3' distance='1' blur='1' angle='90'/>
					</effects>
				</text>
			</label>;
		
		public var styleBtn:XML = 
			<states>
				<normal radius='0'>
					<fill color='#686A66,#575654' angle="90"/>
					<img/>
				</normal>
				<hover radius='0'>
					<border color='#2D2C2A' alpha='1' thikness='1'/>
					<fill color='#57524F,#4B4643' angle="90"/>
					<img/>
				</hover>
				<down radius='0'>
					<border color='#2D2C2A' alpha='1' thikness='1'/>
					<fill color='#2D2C2A,#262626' angle="90"/>
					<img/>
				</down>
			</states>;
		
		public var styleNav:XML = 
			<states>
				<normal radius='0'>
					<fill color='#686A66,#575654' angle="90"/>
					<img/>
				</normal>
				<hover radius='0'>
					<fill color='#57524F,#4B4643' angle="90"/>
					<img/>
				</hover>
				<down radius='0'>
					<fill color='#2D2C2A,#262626' angle="90"/>
					<img/>
				</down>
			</states>;
	}
}