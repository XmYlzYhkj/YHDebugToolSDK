//
//  YHDebugToolDicToModel.h
//  FLEX
//
//  Created by zxl on 2020/9/7.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/*!
* @brief JSON转换成Model，或者把Model转换成JSON
* @author zxl
*/
@interface YHDebugToolDicToModel : NSObject

/*!
 * @brief 把对象（Model）转换成字典
 * @param model 模型对象
 * @return 返回字典
 */
+ (NSDictionary *)dictionaryWithModel:(id)model;

/*!
 * @brief 获取Model的所有属性名称
 * @param model 模型对象
 * @return 返回模型中的所有属性值
 */
+ (NSArray *)propertiesInModel:(id)model;

/*!
 * @brief 把字典转换成模型，模型类名为className
 * @param dict 字典对象
 * @param className 类名
 * @return 返回数据模型对象
 */
+ (id)modelWithDict:(NSDictionary *)dict className:(NSString *)className;

@end

NS_ASSUME_NONNULL_END
