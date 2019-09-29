package com.jeeplus.common.utils;


import org.junit.Test;

import java.text.SimpleDateFormat;
import java.time.DayOfWeek;
import java.time.Duration;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.temporal.TemporalAdjusters;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.List;

public class Date8Util {

	/**
	 * 获取某天的开始日期
	 *
	 * @param offset 0今天，1明天，-1昨天，依次类推
	 * @return
	 */
	public static LocalDateTime dayStart(int offset) {
		return LocalDate.now().plusDays(offset).atStartOfDay();
	}

	/**
	 * 获取此刻与相对当天第day天的起始时间相隔的秒数。day为0表示今天的起始时间；1明天，2后天，-1昨天，-2前天等，依次例推。
	 *
	 * @param day
	 * @return
	 */
	public static int ttl(int day) {
		LocalDateTime now = LocalDateTime.now();
		LocalDateTime time = LocalDate.now().plusDays(day).atStartOfDay();
		int ttl = (int) Duration.between(now, time).toMillis() / 1000;
		return ttl;
	}

	/**
	 * 获取某周的开始日期
	 *
	 * @param offset 0本周，1下周，-1上周，依次类推
	 * @return
	 */
	public static LocalDate weekStart(int offset) {
		LocalDate localDate = LocalDate.now().plusWeeks(offset);
		return localDate.with(DayOfWeek.MONDAY);
	}

	/**
	 * 获取某月的开始日期
	 *
	 * @param offset 0本月，1下个月，-1上个月，依次类推
	 * @return
	 */
	public static LocalDate monthStart(int offset) {
		return LocalDate.now().plusMonths(offset).with(TemporalAdjusters.firstDayOfMonth());
	}

	/**
	 * 获取某季度的开始日期
	 * 季度一年四季， 第一季度：2月-4月， 第二季度：5月-7月， 第三季度：8月-10月， 第四季度：11月-1月
	 *
	 * @param offset 0本季度，1下个季度，-1上个季度，依次类推
	 * @return
	 */
	public static LocalDate quarterStart(int offset) {
		final LocalDate date = LocalDate.now().plusMonths(offset * 3);
		int month = date.getMonth().getValue();//当月
		int start = 0;
		if (month >= 2 && month <= 4) {//第一季度
			start = 2;
		} else if (month >= 5 && month <= 7) {//第二季度
			start = 5;
		} else if (month >= 8 && month <= 10) {//第三季度
			start = 8;
		} else if ((month >= 11 && month <= 12)) {//第四季度
			start = 11;
		} else if (month == 1) {//第四季度
			start = 11;
			month = 13;
		}
		return date.plusMonths(start - month).with(TemporalAdjusters.firstDayOfMonth());
	}

	/**
	 * 获取某年的开始日期
	 *
	 * @param offset 0今年，1明年，-1去年，依次类推
	 * @return
	 */
	public static LocalDate yearStart(int offset) {
		return         LocalDate.now().plusYears(offset).with(TemporalAdjusters.firstDayOfYear());
	}

	@Test
	public static void main(String[] args){
		/*LocalDate thisWeekMondy=Date8Util.weekStart(0);
		System.out.println("本周第一天:"+thisWeekMondy);*/
	}
}
