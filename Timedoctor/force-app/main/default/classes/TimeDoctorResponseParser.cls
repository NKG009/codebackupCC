public class TimeDoctorResponseParser {
    public List<list<Data>> data;
	public class Data {
        public String userId ;
		public String start ;
		public String end1 ;// in json: end
		public Integer project ;
		public List<String> date1 ;// in json: date
		public List<Integer> score ;
		public Integer total ;
	}
}