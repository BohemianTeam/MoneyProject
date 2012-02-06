

#ifndef _LOGGER_H_
#define _LOGGER_H_

#define LOG_ERROR 0
#define LOG_INFO  1
#define LOG_DEBUG 2

#ifdef DEBUG
#   define LOG_LEVEL LOG_DEBUG
#else
#   define LOG_LEVEL LOG_ERROR
#endif

#if (LOG_LEVEL >= LOG_DEBUG)
#   define DLog(fmt, ...) DLog((@"%s [%d] [DEBUG] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)
#   define ILog(fmt, ...) DLog((@"%s [%d] [INFO] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)
#   define ELog(fmt, ...) DLog((@"%s [%d] [ERROR] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)
#elif (LOG_LEVEL >= LOG_INFO)
#   define DLog(...)
#   define ILog(fmt, ...) DLog((@"%s [%d] [INFO] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)
#   define ELog(fmt, ...) DLog((@"%s [%d] [ERROR] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)
#else
#   define DLog(...)
#   define ILog(...)
#   define ELog(fmt, ...) DLog((@"%s [%d] [ERROR] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)
#endif

#endif