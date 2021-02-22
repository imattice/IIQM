# Dexcom Code Challenge -- Crunching Large Data Sets

-------------------------------------------------------


## BACKGROUND:

When working with large data sets at Dexcom, we often do not have the luxury of being able to make large calculations from scratch.  Instead, we need to be able to perform calculations incrementally as data is added to the system.


The included Swift code sample calculates the Incremental Interquartile Mean of a large data set.  The data.txt file contains 100,000 integer values between 0 and 600 (there is also a smaller file data-20k.txt with 20k values to work with to make things a little faster).  The given code calculates the Interquartile Mean of the first 4 values in the data set, then the first 5 values, then the first 6 values, etc, until it has calculated the IQM of all 100,000 values (99997 IQM calculations total).


This problem is meant to give you the chance to show us the way you go about solving problems and the techniques you use when developing software.  The more you tell us about your thinking and reasons behind the work you’ve done, the better understanding we’ll have of how you work!


## INSTRUCTIONS:

The challenge has two parts. You may attempt *one* or the *other*, or *both*. If you attempt both parts, submit a single project that includes all changes.


## PART 1: REFACTORING

The code provided is written in a very rudimentary style. It is difficult to understand, and does not communicate intent or functionality.


Can you improve the code such that:


1. It communicates function and intention clearly, AND

2. It is the kind of code YOU want to read and write.


Please provide your code, any tests you create, and answers to the following questions:


1. Explain your improvement process, and why you chose each step.
    1) Move the calculate:path method to an Array<Int> extension.  This will allow us to act on the data directly, which will improve readability as well as give this functionality to any Array<Int> in the app without having to call a custom class.
    2) Create a class that is designated for reading the text file.  That is a unique behavior that should be in its own class.  This also leaves open the potential to expand it if in the future we need to read other files.
    3) Both the Array<Int> extension and the TextReader class can be easily tested.  We can develop these using TDD to ensure that any future changes do not affect the expected outcome

2. What improvements did you make to ensure that future developers could quickly and easily understand this code?
    * Used source control so that I could be making edits on a private branch while other developers are working on branches that still utilize the original IIQM class
    * Use proper naming conventions and add definitions to all classes, methods, and properties so that it is clear what they are used for.
        For example, renaming IIQM to IIQMCalculator lets to developer tha is using the class what it's purpose is.  There is also a definition included so that Xcode can display that in the autocomplete dropdown.
    * Adding comments to lines of code that could be difficult to read and are not super obvious
        For example, the line `return Double(self.reduce(0) { $0 + $1 }) / Double(self.count)` is efficient and succinct, but not particularly readable.  Adding a comment to explain that it is just adding an array and dividing by the count takes away the work of parsing through the code
            * Some comments are left to show my thought process, as well as some code that I explored, but didn't end up using.  These would normally be deleted, but I left them in for this code challenge. 
    * Organizing the file structure.  While it was already pretty organized, keeping the Array extension and deprecated class separate can keep focus on on the other critical app files
    * Deprecate the old IIQM class so that future developers do not use it. This also sets it up to be permanently removed in the future



## PART 2: OPTIMIZATION

The code provided is slow.  On a modern MacBook Pro it takes over 10 minutes to execute.

Can you optimize the code such that:


1. It runs significantly faster, AND

2. It still produces the same output as the example code, for the given data.txt input, AND

3. It still calculates the Incremental Interquartile Mean after each value is read, AND

4. It will continue to produce correct output given any data set with any number of integer values between 0 and 600.


Please provide the optimized code, an automated test that proves that your code works, and answers to the following questions:


1. Explain how your optimization works and why you took this approach
    * I looked into a few different ways that this could be optimized, and decided that the best method would be to keep track of the sum of the median quartile.  As new values are added, they are insert-sorted into an array where we can keep track of them.  If the new value belongs in the median quartile, we can add that single value to the sum.  Additionally, if the q1 or q3 shifts when the new value is added, we can add or subtract those values from the sum.  When we need the interquartile mean, we can just return that sum divided by 2.

2. Would your approach continue to work if there were millions or billions of input values?
    * This method would work well for large data sets since we are only ever changing the sum by 3 values, at most, for each iteration.
    * The sorting method used to keep track of the new values could be an issue, but I think we could use a binary search tree to find the right index instead of iterating through the whole array.  In the both cases, the worst case would be that the entire array would need to be shifted.
    * We are also keeping this large array in memory, which for millions or billions of values seems significant.  If this becomes and issue, we may want to implement a size limit after which we start dumping old data.

3. Would your approach still be efficient if you needed to store the intermediate state between each IQM calculation in a data store?  If not, how would you change it to meet this requirement?
    * If we still had access to the data file souce, we would just need to store the last index of the loop so that we could resume the calculation from there.  We could also store the sum of the median so that would not have to be recalculated, as well as the q1 and q3 index.
    * We could also implement a start() and resume() function that would give an entry point to the calculation.  These would use the stored values to restart the calculation
