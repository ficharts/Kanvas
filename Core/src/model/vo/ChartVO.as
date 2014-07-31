package model.vo
{
	public class ChartVO extends ElementVO
	{
		public function ChartVO()
		{
			super();
		}
		
		/**
		 * 图表的配置文件，包含配置与数据 
		 */		
		public var data:XML = <config ySuffix="万">
								    <axis>
								        <x type="field"/>
								        <y type="linear"/>
								    </axis>
								    <series>
								        <column xField='label' yField='value'/>
								    </series>
								    <data>
								        <set label='1月' value='279'/>
								        <set label='2月' value='410' />
								        <set label='3月' value='325'/>
								        <set label='4月' value='572'/>
								        <set label='5月' value='629'/>
								        <set label='6月' value='710'/>
								        <set label='7月' value='489'/>
								        <set label='8月' value='635'/>
								        <set label='9月' value='750'/>
								        <set label='10月' value='600'/>
								        <set label='11月' value='760'/>
								        <set label='12月' value='950'/>
								    </data>
								</config>;
	}
}