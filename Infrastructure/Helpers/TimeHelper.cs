using System;

namespace Infrastructure.Helpers
{
    /// <summary>
    /// 时间处理帮助类
    /// 统一处理时区问题，确保所有时间都使用正确的时区
    /// </summary>
    public static class TimeHelper
    {
        /// <summary>
        /// 获取当前中国标准时间（UTC+8）
        /// </summary>
        /// <returns>当前中国标准时间</returns>
        public static DateTime Now => GetChinaStandardTime();

        /// <summary>
        /// 获取当前中国标准时间（UTC+8）
        /// </summary>
        /// <returns>当前中国标准时间</returns>
        public static DateTime GetChinaStandardTime()
        {
            // 获取UTC时间
            var utcNow = DateTime.UtcNow;
            
            // 转换为中国标准时间（UTC+8）
            var chinaTimeZone = TimeZoneInfo.FindSystemTimeZoneById("China Standard Time");
            
            // 如果找不到中国时区，使用手动计算（UTC+8）
            if (chinaTimeZone == null)
            {
                return utcNow.AddHours(8);
            }
            
            return TimeZoneInfo.ConvertTimeFromUtc(utcNow, chinaTimeZone);
        }

        /// <summary>
        /// 将UTC时间转换为中国标准时间
        /// </summary>
        /// <param name="utcTime">UTC时间</param>
        /// <returns>中国标准时间</returns>
        public static DateTime ConvertUtcToChinaTime(DateTime utcTime)
        {
            if (utcTime.Kind != DateTimeKind.Utc)
            {
                utcTime = DateTime.SpecifyKind(utcTime, DateTimeKind.Utc);
            }

            var chinaTimeZone = TimeZoneInfo.FindSystemTimeZoneById("China Standard Time");
            
            if (chinaTimeZone == null)
            {
                return utcTime.AddHours(8);
            }
            
            return TimeZoneInfo.ConvertTimeFromUtc(utcTime, chinaTimeZone);
        }

        /// <summary>
        /// 将中国标准时间转换为UTC时间
        /// </summary>
        /// <param name="chinaTime">中国标准时间</param>
        /// <returns>UTC时间</returns>
        public static DateTime ConvertChinaTimeToUtc(DateTime chinaTime)
        {
            var chinaTimeZone = TimeZoneInfo.FindSystemTimeZoneById("China Standard Time");
            
            if (chinaTimeZone == null)
            {
                return chinaTime.AddHours(-8);
            }
            
            return TimeZoneInfo.ConvertTimeToUtc(chinaTime, chinaTimeZone);
        }

        /// <summary>
        /// 获取当前时间的Unix时间戳（秒）
        /// </summary>
        /// <returns>Unix时间戳</returns>
        public static long GetUnixTimestamp()
        {
            return ((DateTimeOffset)Now).ToUnixTimeSeconds();
        }

        /// <summary>
        /// 获取当前时间的Unix时间戳（毫秒）
        /// </summary>
        /// <returns>Unix时间戳（毫秒）</returns>
        public static long GetUnixTimestampMilliseconds()
        {
            return ((DateTimeOffset)Now).ToUnixTimeMilliseconds();
        }

        /// <summary>
        /// 将Unix时间戳转换为中国标准时间
        /// </summary>
        /// <param name="timestamp">Unix时间戳（秒）</param>
        /// <returns>中国标准时间</returns>
        public static DateTime FromUnixTimestamp(long timestamp)
        {
            var utcTime = DateTimeOffset.FromUnixTimeSeconds(timestamp).DateTime;
            return ConvertUtcToChinaTime(utcTime);
        }

        /// <summary>
        /// 将Unix时间戳（毫秒）转换为中国标准时间
        /// </summary>
        /// <param name="timestamp">Unix时间戳（毫秒）</param>
        /// <returns>中国标准时间</returns>
        public static DateTime FromUnixTimestampMilliseconds(long timestamp)
        {
            var utcTime = DateTimeOffset.FromUnixTimeMilliseconds(timestamp).DateTime;
            return ConvertUtcToChinaTime(utcTime);
        }
    }
}
