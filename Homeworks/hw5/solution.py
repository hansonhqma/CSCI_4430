def binarySearch(num, nums):
    left = 0
    right = len(nums)-1
    while left < right:
        mid = (left+right)//2
        if nums[mid] < num:
            left = mid+1
        else:
            right = mid
    return left

def linearSearch(num, nums):
    for i in range(len(nums)):
        if num <= nums[i]:
            return i

def lengthOfLIS(nums):
    ans = [nums[0]]
    for i in range(1, len(nums)):
        if nums[i] => ans[-1]:
            ans.append(nums[i])
        else:
            index = linearSearch(nums[i],ans)
            ans[index] = nums[i]
    return ans



