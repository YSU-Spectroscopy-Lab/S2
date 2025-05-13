function closestNum = findClosestNum(array, value)
    [~, index] = min(abs(array - value));
    closestNum = array(index);
end